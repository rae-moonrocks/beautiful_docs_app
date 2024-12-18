class Document < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  def contributor_name
    contributor.blank? ? "Unknown" : contributor
  end
end
