require "test_helper"

class ArticleMarkdownTest < ActiveSupport::TestCase
  BLOB = <<~MD
    ---
    title: "Postgres 101: indexes"
    summary: A primer.
    author: Maya Okafor
    category: devops
    published_at: 2026-11-10 09:30
    tags: [postgres, Databases]
    featured: true
    ---

    ## Indexes

    Use them.
  MD

  test "assigns every field from front matter" do
    article = Article.new
    assert ArticleMarkdown.new(BLOB).assign_to(article)
    assert article.save, article.errors.full_messages.to_sentence

    assert_equal "Postgres 101: indexes", article.title
    assert_equal "postgres-101-indexes", article.slug
    assert_equal "A primer.", article.summary
    assert_equal authors(:maya), article.author
    assert_equal categories(:devops), article.category
    assert_equal Time.zone.parse("2026-11-10 09:30"), article.published_at
    assert_equal %w[ postgres databases ], article.tag_list
    assert article.featured?
    assert_equal "## Indexes\n\nUse them.", article.body
  end

  test "creates a new author when the name is unknown" do
    article = Article.new
    ArticleMarkdown.new(BLOB.sub("Maya Okafor", "New Writer").sub("featured: true", "author_role: Intern")).assign_to(article)
    assert_difference("Author.count") { article.save! }
    assert_equal "Intern", article.author.role
  end

  test "blank published_at makes a draft" do
    article = Article.new
    ArticleMarkdown.new(BLOB.sub(/published_at:.*/, "published_at:")).assign_to(article)
    article.save!
    assert_equal "draft", article.status
  end

  test "reports missing front matter" do
    article = Article.new
    assert_not ArticleMarkdown.new("# Just a heading").assign_to(article)
    assert_match "front matter", article.errors.full_messages.first
  end

  test "reports unknown fields, unknown categories and bad dates" do
    article = Article.new
    assert_not ArticleMarkdown.new(BLOB.sub("featured", "featurd")).assign_to(article)
    assert_match "Unknown front matter field: featurd", article.errors.full_messages.to_sentence

    article = Article.new
    assert_not ArticleMarkdown.new(BLOB.sub("category: devops", "category: Cooking")).assign_to(article)
    assert_match "Unknown category 'Cooking'", article.errors.full_messages.to_sentence

    article = Article.new
    assert_not ArticleMarkdown.new(BLOB.sub("2026-11-10 09:30", "next tuesday")).assign_to(article)
    assert_match "not a valid date", article.errors.full_messages.to_sentence
  end

  test "an unknown author is not persisted when the article fails" do
    article = Article.new
    ArticleMarkdown.new(BLOB.sub("Maya Okafor", "Ghost").sub("category: devops", "category: Cooking")).assign_to(article)
    assert_no_difference("Author.count") { article.save }
  end

  test "reads cover image fields" do
    article = Article.new
    blob = BLOB.sub("featured: true", "image: /images/c.png\nimage_alt: Cover art\nimage_caption: Illustration")
    assert ArticleMarkdown.new(blob).assign_to(article)
    assert_equal [ "/images/c.png", "Cover art", "Illustration" ], [ article.image, article.image_alt, article.image_caption ]
    assert_includes ArticleMarkdown.from_article(article), "image: \"/images/c.png\""
  end

  test "round-trips an existing article" do
    article = articles(:kamal)
    copy = Article.find(article.id)
    assert ArticleMarkdown.new(ArticleMarkdown.from_article(article)).assign_to(copy)
    assert_empty copy.changed
  end

  test "the template is valid" do
    article = Article.new
    assert ArticleMarkdown.new(ArticleMarkdown.template).assign_to(Article.new(author: authors(:maya)))
    assert ArticleMarkdown.new(ArticleMarkdown.template.sub(/^category: \S+/, "category: Languages")).assign_to(article)
    assert article.valid?, article.errors.full_messages.to_sentence
  end
end
