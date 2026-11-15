require "test_helper"

class Admin::ArticlesControllerTest < ActionDispatch::IntegrationTest
  BLOB = <<~MD
    ---
    title: Pasted article
    author: Maya Okafor
    category: Languages
    published_at: 2026-11-01 10:00
    tags: [paste]
    ---

    Hello from **markdown**.
  MD

  test "requires sign in" do
    get admin_root_path
    assert_redirected_to new_session_path
    post admin_articles_path, params: { markdown: BLOB }
    assert_redirected_to new_session_path
  end

  test "creates an article from a pasted markdown blob" do
    sign_in_as users(:one)
    get new_admin_article_path
    assert_response :success
    assert_select "textarea[name=markdown]", /title: Your headline here/

    assert_difference("Article.count") do
      post admin_articles_path, params: { markdown: BLOB }
    end
    article = Article.find_by!(slug: "pasted-article")
    assert_redirected_to edit_admin_article_path(article)
    assert_equal categories(:languages), article.category
    assert_equal [ "paste" ], article.tag_list
  end

  test "shows errors and keeps the pasted text when invalid" do
    sign_in_as users(:one)
    assert_no_difference("Article.count") do
      post admin_articles_path, params: { markdown: BLOB.sub("Languages", "Knitting") }
    end
    assert_response :unprocessable_entity
    assert_select ".flash--alert", /Unknown category 'Knitting'/
    assert_select "textarea[name=markdown]", /Knitting/
  end

  test "edits an article through its markdown" do
    sign_in_as users(:one)
    article = articles(:kamal)
    get edit_admin_article_path(article)
    assert_select "textarea[name=markdown]", /title: Deploying with Kamal/

    patch admin_article_path(article), params: { markdown: ArticleMarkdown.from_article(article).sub("Deploying with Kamal", "Deploying with Kamal 2") }
    assert_redirected_to edit_admin_article_path(article)
    assert_equal "Deploying with Kamal 2", article.reload.title
  end

  test "downloads the template" do
    sign_in_as users(:one)
    get template_admin_articles_path
    assert_response :success
    assert_equal "text/markdown", response.media_type
    assert_includes response.body, "title: Your headline here"
  end

  test "dashboard and other admin pages render" do
    sign_in_as users(:one)
    [ admin_root_path, admin_articles_path, admin_categories_path, admin_authors_path, admin_subscribers_path,
      new_admin_category_path, edit_admin_category_path(categories(:devops)), new_admin_author_path,
      edit_admin_author_path(authors(:maya)) ].each do |path|
      get path
      assert_response :success, path
    end
  end
end
