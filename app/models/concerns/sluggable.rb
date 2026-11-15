module Sluggable
  extend ActiveSupport::Concern

  class_methods do
    def slug_from(attribute)
      define_method(:slug_source) { public_send(attribute) }
    end
  end

  included do
    before_validation :assign_slug
    validates :slug, presence: true, uniqueness: true,
      format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, message: "may only contain lowercase letters, numbers and dashes" }
  end

  def to_param
    slug_was.presence || slug
  end

  private
    def assign_slug
      return if slug.present? || slug_source.blank?

      base = slug_source.to_s.parameterize.first(80).delete_suffix("-")
      candidate = base
      counter = 2
      while self.class.where.not(id: id).exists?(slug: candidate)
        candidate = "#{base}-#{counter}"
        counter += 1
      end
      self.slug = candidate
    end
end
