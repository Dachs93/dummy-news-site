atom_feed(root_url: root_url, language: "en-US") do |feed|
  feed.title "software-devs"
  feed.subtitle "News covering the latest in software development"
  feed.updated(@articles.first&.published_at || Time.current)

  @articles.each do |article|
    feed.entry(article, published: article.published_at, updated: article.updated_at, url: article_url(article)) do |entry|
      entry.title article.title
      entry.summary article.excerpt
      cover = article.image? ? image_tag(absolute_url(article.image), alt: article.image_alt) : ""
      entry.content cover + article.body_html, type: "html"
      entry.category term: article.category.slug, label: article.category.name
      entry.author { |author| author.name article.author.name }
    end
  end
end
