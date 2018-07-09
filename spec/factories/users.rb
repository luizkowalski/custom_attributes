FactoryBot.define do
  factory :user do
    company { create(:company) }
    email { Faker::Internet.email }
  end
end
