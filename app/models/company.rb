class Company < ApplicationRecord
  AttributeNotRegisted = Class.new(RuntimeError)
  serialize :custom_data, Array
end
