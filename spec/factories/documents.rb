FactoryBot.define do
  factory :document do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    url { Faker::Internet.url }
    contributor { Faker::Name.name }
    contributor_type { [ 'Github', 'Twitter' ].sample }
    slug { title.parameterize }
  end
end
