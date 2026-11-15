module ApplicationHelper
  SITE_NAME = "software-devs".freeze
  SITE_TAGLINE = "News covering the latest in software development".freeze

  def page_title
    [ content_for(:title).presence, SITE_NAME ].compact.join(" · ")
  end

  def meta_description
    content_for(:description).presence || "#{SITE_TAGLINE} — languages, frameworks, DevOps, AI tooling, security and open source."
  end

  def accent_style(category)
    "--hue: #{Zlib.crc32(category.slug) % 360}"
  end

  def pub_date(article, format: :long)
    return "Draft" unless article.published_at
    time_tag article.published_at, article.published_at.to_date.to_fs(format == :short ? :short : :long)
  end

  def relative_date(article)
    return "Draft" unless article.published_at
    label = article.published_at > 7.days.ago ? "#{time_ago_in_words(article.published_at)} ago" : article.published_at.to_date.to_fs(:long)
    time_tag article.published_at, label, title: article.published_at.to_fs(:long)
  end

  def absolute_url(path_or_url)
    path_or_url.to_s.start_with?("/") ? request.base_url + path_or_url : path_or_url
  end

  def cover_image(article, css_class:, link: true, eager: false)
    return unless article.image?

    img = image_tag(article.image, alt: article.image_alt, class: css_class, width: 1200, height: 630,
                    loading: (eager ? "eager" : "lazy"), decoding: "async", fetchpriority: (eager ? "high" : nil))
    link ? link_to(img, article_path(article), tabindex: -1, aria: { hidden: true }) : img
  end

  def nav_link(label, path, **options)
    active = current_page?(path)
    link_to label, path, **options, class: class_names(options[:class], "is-active": active), aria: { current: (active ? "page" : nil) }
  end
end
