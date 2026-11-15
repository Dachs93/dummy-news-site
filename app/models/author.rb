class Author < ApplicationRecord
  include Sluggable
  slug_from :name

  has_many :articles, dependent: :restrict_with_error

  validates :name, presence: true

  def initials
    name.split.map(&:first).first(2).join.upcase
  end
end
