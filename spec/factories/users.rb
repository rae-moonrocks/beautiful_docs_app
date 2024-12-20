FactoryBot.define do
  sequence(:user_factory_email) { |n| "person#{n}@example.com" }
  factory :user do
    id { }
    email { generate(:user_factory_email) }
    password { "MyString" }
  end
end
