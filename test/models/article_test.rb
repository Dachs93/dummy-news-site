require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "published scope excludes drafts and scheduled articles" do
    assert_equal %w[ deploying-with-kamal rust-ownership ], Article.published.recent.pluck(:slug)
  end

  test "generates a unique slug from the title" do
    article = Article.create!(title: "Deploying with Kamal", body: "x", category: categories(:devops), author: authors(:maya))
    assert_equal "deploying-with-kamal-2", article.slug
  end

  test "normalizes tags and computes reading time" do
    article = Article.create!(title: "T", body: "word " * 700, tags: " Rails, KAMAL ,rails,, Dev Ops ",
                              category: categories(:devops), author: authors(:maya))
    assert_equal %w[ rails kamal dev-ops ], article.tag_list
    assert_equal 4, article.reading_minutes
  end

  test "tagged and search scopes" do
    assert_equal [ articles(:rust) ], Article.tagged("rust").to_a
    assert_includes Article.search("containers"), articles(:kamal)
    assert_empty Article.search("100%")
  end

  test "renders markdown without allowing raw html" do
    article = Article.new(body: "**bold** <script>alert(1)</script>")
    assert_includes article.body_html, "<strong>bold</strong>"
    assert_not_includes article.body_html, "<script>"
  end
end

class ArticleImageTest < ActiveSupport::TestCase
  test "image must be an http(s) URL or absolute path, and needs alt text" do
    article = articles(:kamal)
    article.image = "javascript:alert(1)"
    assert_not article.valid?
    assert_includes article.errors[:image], "must be an http(s) URL or a path starting with /"

    article.image = "/images/cover.png"
    assert_not article.valid?
    assert article.errors[:image_alt].any?

    article.image_alt = "A cover"
    assert article.valid?
  end

  test "a standalone image becomes a figure with its title as caption" do
    html = Article.new(body: "Intro\n\n![A diagram](/d.png \"How it works\")\n\nInline ![icon](/i.png) here").body_html
    assert_includes html, %(<figure><img src="/d.png" alt="A diagram" title="How it works" loading="lazy" decoding="async"><figcaption>How it works</figcaption></figure>)
    assert_includes html, %(<p>Inline <img src="/i.png" alt="icon" loading="lazy" decoding="async"> here</p>)
  end
end
