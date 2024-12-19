class Document < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :url, presence: true, format: { with: URI.regexp }, uniqueness: true, if: :url_present?
  validates :title, uniqueness: true

  def contributor_name
    contributor.blank? ? "Unknown" : contributor
  end

  private

  def url_present?
    url.present?
  end
end
