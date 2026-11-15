class Article < ApplicationRecord
  include Sluggable
  slug_from :title

  WORDS_PER_MINUTE = 230

  belongs_to :category
  belongs_to :author

  validates :title, presence: true, length: { maximum: 160 }
  validates :body, presence: true
  validates :summary, length: { maximum: 400 }
  validates :image, format: { with: %r{\A(https?://|/)\S+\z}, message: "must be an http(s) URL or a path starting with /" }, allow_blank: true
  validates :image_alt, presence: { message: "is required when an image is set (describe the image for screen readers)" }, if: :image?

  before_save :normalize_tags, :compute_reading_minutes

  scope :published, -> { where.not(published_at: nil).where(published_at: ..Time.current) }
  scope :recent, -> { order(published_at: :desc, id: :desc) }
  scope :featured, -> { where(featured: true) }
  scope :tagged, ->(tag) { where("(',' || tags || ',') LIKE ?", "%,#{sanitize_sql_like(tag.to_s.downcase)},%") }
  scope :search, ->(query) {
    terms = query.to_s.split.first(8)
    terms.reduce(all) do |scope, term|
      pattern = "%#{sanitize_sql_like(term)}%"
      scope.where("articles.title LIKE :q OR articles.summary LIKE :q OR articles.body LIKE :q OR articles.tags LIKE :q", q: pattern)
    end
  }

  def published?
    published_at.present? && published_at <= Time.current
  end

  def status
    if published_at.nil? then "draft"
    elsif published_at > Time.current then "scheduled"
    else "published"
    end
  end

  def tag_list
    tags.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  def tag_list=(value)
    self.tags = Array(value).join(",")
  end

  def body_html
    html = Commonmarker.to_html(body.to_s,
      options: { extension: { strikethrough: true, table: true, autolink: true, tasklist: true, header_ids: "" },
                 render: { unsafe: false } },
      plugins: { syntax_highlighter: nil })
    figureize_images(html).html_safe
  end

  def excerpt
    summary.presence || body.to_s.gsub(/[#*`>\[\]_]/, "").squish.truncate(220)
  end

  def related(limit: 3)
    Article.published.recent.where(category_id: category_id).where.not(id: id).includes(:author, :category).limit(limit)
  end

  private
    # Lazy-load body images, and turn a paragraph holding only an image into a
    # <figure>. The Markdown title becomes the caption: ![alt](src "Caption").
    def figureize_images(html)
      fragment = Nokogiri::HTML5.fragment(html)
      fragment.css("img").each do |img|
        img["loading"] = "lazy"
        img["decoding"] = "async"
        parent = img.parent
        next unless parent&.name == "p" && parent.element_children.size == 1 && parent.text.strip.empty?

        figure = Nokogiri::XML::Node.new("figure", fragment.document)
        figure.add_child(img.dup)
        if (caption = img["title"]).present?
          figure.add_child(Nokogiri::XML::Node.new("figcaption", fragment.document).tap { it.content = caption })
        end
        parent.replace(figure)
      end
      fragment.to_html
    end

    def normalize_tags
      self.tags = tags.to_s.split(",").map { |t| t.strip.downcase.gsub(/[^a-z0-9.+#\- ]/, "").squish.tr(" ", "-") }
                      .reject(&:blank?).uniq.first(10).join(",")
    end

    def compute_reading_minutes
      self.reading_minutes = [ (body.to_s.split.size / WORDS_PER_MINUTE.to_f).ceil, 1 ].max
    end
end
