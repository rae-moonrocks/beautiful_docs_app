require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'validations' do
    subject { FactoryBot.build(:document) }

    it { should validate_presence_of(:url) }
    it { should validate_uniqueness_of(:title) }

    it 'validates uniqueness of url' do
      FactoryBot.create(:document, url: 'http://example.com', title: 'Title 1')
      document = FactoryBot.build(:document, url: 'http://example.com', title: 'Title 2')
      expect(document).not_to be_valid
      expect(document.errors[:url]).to include('has already been taken')
    end

    it 'validates format of url' do
      valid_url = "https://example.com"
      invalid_url = "invalid_url"

      expect(FactoryBot.build(:document, url: valid_url)).to be_valid
      expect(FactoryBot.build(:document, url: invalid_url)).not_to be_valid
    end
  end

  describe 'friendly_id' do
    it 'generates a slug from the title' do
      document = FactoryBot.create(:document, title: "Test Title")
      expect(document.slug).to eq("test-title")
    end
  end

  describe '#contributor_name' do
    it 'returns the contributor name if present' do
      document = FactoryBot.build(:document, contributor: "John Doe")
      expect(document.contributor_name).to eq("John Doe")
    end

    it 'returns "Unknown" if contributor is blank' do
      document = FactoryBot.build(:document, contributor: nil)
      expect(document.contributor_name).to eq("Unknown")
    end
  end
end
