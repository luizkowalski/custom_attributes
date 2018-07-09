FactoryBot.define do
  factory :company do
    name 'Test company'
    custom_data %w[shoe_size laces_length]
  end
end
