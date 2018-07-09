FactoryBot.define do
  factory :user do
    company { create(:company) }
    email 'test@user.com'
  end
end
