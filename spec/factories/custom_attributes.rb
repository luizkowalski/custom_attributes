FactoryBot.define do
  factory :custom_attribute, class: 'CustomAttributes' do
    company { create(:company) }
    user { create(:user) }
    field_name 'test'
    field_value 'value'
  end
end
