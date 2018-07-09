module Customizable
  extend ActiveSupport::Concern
  included do
    has_many :custom_attributes, dependent: :destroy

    define_singleton_method 'search_by' do |opts|
      joins(:custom_attributes)
        .where(company: opts[:company])
        .where('custom_attributes.field_name = ? and custom_attributes.field_value = ?', opts[:attribute], opts[:field_value])
    end

    define_method 'configure_attribute' do |attribute, new_value|
      attribute_registered?(attribute)
      custom_attribute = custom_attributes.find_or_create_by(company: company, field_name: attribute)
      custom_attribute.update(field_value: new_value)
    end
  end

  def attribute_registered?(attribute)
    raise Company::AttributeNotRegisted unless company.custom_data.include?(attribute)
  end
end
