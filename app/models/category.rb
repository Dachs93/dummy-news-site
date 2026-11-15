class Category < ApplicationRecord
  include Sluggable
  slug_from :name

  has_many :articles, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:position, :name) }
end
