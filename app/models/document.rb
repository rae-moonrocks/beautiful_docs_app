class Document < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :url, presence: true, format: { with: URI.regexp }, uniqueness: true
  validates :title, uniqueness: true

  def contributor_name
    contributor.blank? ? "Unknown" : contributor
  end
end
