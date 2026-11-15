# An image uploaded through the admin so it can be referenced from article Markdown.
class Upload < ApplicationRecord
  CONTENT_TYPES = %w[ image/png image/jpeg image/gif image/webp image/avif ].freeze
  MAX_SIZE = 10.megabytes

  has_one_attached :file

  validates :file, presence: true
  validate :file_is_an_allowed_image

  before_validation { self.title = file.filename.base.humanize if title.blank? && file.attached? }

  private
    def file_is_an_allowed_image
      return unless file.attached?

      errors.add(:file, "must be a PNG, JPEG, GIF, WebP or AVIF image") unless file.content_type.in?(CONTENT_TYPES)
      errors.add(:file, "must be smaller than #{MAX_SIZE / 1.megabyte} MB") if file.byte_size > MAX_SIZE
    end
end
