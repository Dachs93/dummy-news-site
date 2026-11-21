xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url { xml.loc root_url; xml.changefreq "hourly" }
  xml.url { xml.loc articles_url; xml.changefreq "hourly" }
  xml.url { xml.loc about_url; xml.changefreq "monthly" }
  xml.url { xml.loc contact_url; xml.changefreq "monthly" }
  xml.url { xml.loc editorial_policy_url; xml.changefreq "monthly" }
  @categories.each do |category|
    xml.url { xml.loc category_url(category); xml.changefreq "daily" }
  end
  @articles.each do |article|
    xml.url { xml.loc article_url(article); xml.lastmod article.updated_at.iso8601 }
  end
end
