# Converts between an Article and a single Markdown document with YAML front matter:
#
#   ---
#   title: Deploying Rails with Kamal
#   summary: A short dek shown under the headline.
#   author: Jane Doe
#   category: DevOps
#   published_at: 2026-11-15 09:00
#   tags: [rails, kamal]
#   featured: false
#   image: /images/articles/kamal.svg   # optional cover image (URL or /path)
#   image_alt: Diagram of a Kamal deploy
#   image_caption: Optional caption or credit
#   slug: deploying-rails-with-kamal   # optional
#   ---
#
#   Body in **Markdown**...
class ArticleMarkdown
  FRONT_MATTER = /\A\s*---[ \t]*\r?\n(.*?)\r?\n---[ \t]*(?:\r?\n|\z)(.*)\z/m
  FIELDS = %w[ title slug summary author author_role category published_at tags featured image image_alt image_caption ].freeze
  REQUIRED = %w[ title author category ].freeze

  attr_reader :text, :errors

  def self.from_article(article)
    front = {
      "title" => article.title,
      "summary" => article.summary.presence,
      "author" => article.author&.name,
      "category" => article.category&.name,
      "published_at" => article.published_at&.strftime(article.published_at.sec.zero? ? "%Y-%m-%d %H:%M" : "%Y-%m-%d %H:%M:%S"),
      "tags" => article.tag_list,
      "featured" => article.featured?,
      "image" => article.image.presence,
      "image_alt" => article.image_alt.presence,
      "image_caption" => article.image_caption.presence,
      "slug" => article.slug.presence
    }.compact

    lines = front.map do |key, value|
      if key == "tags"
        "tags: [#{value.map(&:to_json).join(", ")}]"
      else
        { key => value }.to_yaml(line_width: -1).delete_prefix("---\n").chomp
      end
    end
    "---\n#{lines.join("\n")}\n---\n\n#{article.body.to_s.strip}\n"
  end

  TEMPLATE_PATH = Rails.root.join("docs/article_template.md")

  # The blank article shown on the admin "New article" page, read from
  # docs/article_template.md with the publish date set to now.
  def self.template
    TEMPLATE_PATH.read.sub(/^published_at:[^\n#]*/) { "published_at: #{Time.current.strftime("%Y-%m-%d %H:%M")}".ljust(it.length) }
  end

  def initialize(text)
    @text = text.to_s
    @errors = []
  end

  def front_matter
    parse unless defined?(@front_matter)
    @front_matter || {}
  end

  def body
    parse unless defined?(@body)
    @body.to_s
  end

  # Assigns parsed values onto the article. Returns false (with errors copied
  # onto article.errors) if the document itself is malformed.
  def assign_to(article)
    parse
    validate_front_matter
    attributes = errors.empty? ? build_attributes : {}

    if errors.any?
      errors.each { article.errors.add(:base, it) }
      return false
    end

    article.assign_attributes(attributes)
    true
  end

  private
    def parse
      @front_matter = nil
      @body = nil

      match = FRONT_MATTER.match(text)
      unless match
        errors << "Markdown must start with a front matter block between two '---' lines"
        return
      end

      data = YAML.safe_load(match[1], permitted_classes: [ Date, Time ], aliases: false)
      if data.is_a?(Hash)
        @front_matter = data.transform_keys { it.to_s.strip.downcase }
      else
        errors << "Front matter must be a list of 'key: value' lines"
      end
      @body = match[2].strip
    rescue Psych::Exception => e
      errors << "Front matter is not valid YAML (#{e.message.sub(/\A\(<unknown>\): /, "")})"
    end

    def validate_front_matter
      return unless @front_matter

      unknown = @front_matter.keys - FIELDS
      errors << "Unknown front matter #{"field".pluralize(unknown.size)}: #{unknown.join(", ")} (allowed: #{FIELDS.join(", ")})" if unknown.any?

      REQUIRED.each do |key|
        errors << "Front matter is missing '#{key}'" if @front_matter[key].to_s.strip.empty?
      end
      errors << "Article body is empty — add Markdown below the closing '---'" if body.blank?
    end

    def build_attributes
      attrs = {
        title: @front_matter["title"].to_s.strip,
        summary: @front_matter["summary"].to_s.strip.presence,
        body: body,
        tags: Array(@front_matter["tags"].is_a?(String) ? @front_matter["tags"].split(",") : @front_matter["tags"]).join(","),
        featured: ActiveModel::Type::Boolean.new.cast(@front_matter["featured"]) || false,
        published_at: parse_time(@front_matter["published_at"]),
        image: @front_matter["image"].to_s.strip.presence,
        image_alt: @front_matter["image_alt"].to_s.strip.presence,
        image_caption: @front_matter["image_caption"].to_s.strip.presence,
        category: find_category(@front_matter["category"]),
        author: find_or_create_author(@front_matter["author"], @front_matter["author_role"])
      }
      attrs[:slug] = @front_matter["slug"].to_s.strip if @front_matter["slug"].present?
      attrs
    end

    def parse_time(value)
      case value
      when nil, "" then nil
      when Time, DateTime then value.in_time_zone
      when Date then value.in_time_zone
      else
        raise ArgumentError unless value.to_s.strip.match?(/\A\d{4}-\d{2}-\d{2}([ T]\d{1,2}:\d{2}(:\d{2})?)?\s*([+-]\d{2}:?\d{2}|Z|[A-Z]{3,4})?\z/)
        Time.zone.parse(value.to_s) or raise ArgumentError
      end
    rescue ArgumentError
      errors << "published_at '#{value}' is not a valid date/time (try 2026-11-15 09:00, or leave blank for a draft)"
      nil
    end

    def find_category(name)
      key = name.to_s.strip
      Category.where("LOWER(name) = :k OR slug = :k", k: key.downcase).first ||
        Category.find_by(slug: key.parameterize).tap do |category|
          errors << "Unknown category '#{key}'. Use one of: #{Category.ordered.pluck(:name).join(", ")}" unless category
        end
    end

    def find_or_create_author(name, role)
      name = name.to_s.squish
      author = Author.where("LOWER(name) = ?", name.downcase).first
      return author if author

      # Unsaved: it is persisted together with the article, so a failed save leaves no orphan author.
      Author.new(name: name, role: role.to_s.strip.presence)
    end
end
