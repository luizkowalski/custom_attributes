class Company < ApplicationRecord
  serialize :custom_data, Array
end
