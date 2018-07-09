FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    custom_data %w[shoe_size laces_length]
  end
end
