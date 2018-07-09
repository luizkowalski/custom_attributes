module Customizable
  extend ActiveSupport::Concern
  included do
    has_many :custom_attributes, dependent: :destroy

    define_singleton_method 'search_by' do |company, attribute, field_value|
      joins(:custom_attributes)
        .where(company: company)
        .where('custom_attributes.field_name = ? and custom_attributes.field_value = ?', attribute, field_value)
    end

    define_method 'configure_attribute' do |attribute, new_value|
      custom_attribute = custom_attributes.find_or_create_by(company: company, field_name: attribute)
      custom_attribute.update(field_value: new_value)
    end
  end
end
