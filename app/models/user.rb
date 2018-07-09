class User < ApplicationRecord
  include Customizable
  belongs_to :company
end
