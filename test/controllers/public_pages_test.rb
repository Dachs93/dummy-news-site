require "test_helper"

class PublicPagesTest < ActionDispatch::IntegrationTest
  test "home page shows the lead story" do
    get root_path
    assert_response :success
    assert_select "h1.lead__title", "Deploying with Kamal"
  end

  test "article page renders markdown" do
    get article_path(articles(:kamal))
    assert_response :success
    assert_select ".prose strong", "containers"
    assert_select "script[type='application/ld+json']"
  end

  test "cover images show on the article, listings and share tags" do
    articles(:kamal).update!(image: "/images/kamal.png", image_alt: "Kamal cover", image_caption: "Cover art")
    get article_path(articles(:kamal))
    assert_select ".story__hero img[src='/images/kamal.png'][alt='Kamal cover']"
    assert_select ".story__hero figcaption", "Cover art"
    assert_select "meta[property='og:image'][content='http://example.com/images/kamal.png']"
    assert_select "meta[name='twitter:card'][content='summary_large_image']"

    get root_path
    assert_select ".lead__image[src='/images/kamal.png']"
  end

  test "drafts and scheduled articles are not public" do
    get article_path(articles(:draft))
    assert_response :not_found
    get article_path(articles(:scheduled))
    assert_response :not_found
  end

  test "listing pages" do
    [ articles_path, category_path(categories(:devops)), author_path(authors(:maya)), tag_path("rust"),
      search_path(q: "kamal"), search_path, about_path, contact_path, editorial_policy_path ].each do |path|
      get path
      assert_response :success, path
    end
  end

  test "about page links to author bios" do
    get about_path
    assert_select ".prose a[href='#{author_path(authors(:maya))}']", "Maya Okafor"
  end

  test "contact page shows the email address" do
    get contact_path
    assert_select ".prose a[href='mailto:shout@software-devs.com']", "shout@software-devs.com"
  end

  test "editorial policy page" do
    get editorial_policy_path
    assert_select "h1.story__title"
    assert_select ".prose a[href='mailto:shout@software-devs.com']"
    assert_select ".site-footer a[href='#{editorial_policy_path}']", "Editorial policy"
  end

  test "feed and sitemap" do
    get feed_path
    assert_response :success
    assert_includes response.body, "Deploying with Kamal"
    assert_not_includes response.body, "Secret draft"

    get sitemap_path
    assert_response :success
    assert_includes response.body, article_url(articles(:kamal))
  end

  test "www redirects to the apex domain" do
    host! "www.software-devs.com"
    get "/articles?page=2"
    assert_redirected_to "http://software-devs.com/articles?page=2"
  end

  test "newsletter signup" do
    assert_difference("Subscriber.count") do
      post subscribers_path, params: { subscriber: { email: " New@Example.com " } }
    end
    assert_equal "new@example.com", Subscriber.last.email
    assert_no_difference("Subscriber.count") do
      post subscribers_path, params: { subscriber: { email: "new@example.com" } }
    end
  end
end
