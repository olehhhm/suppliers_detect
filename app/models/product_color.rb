class ProductColor < ApplicationRecord
  belongs_to :product
  has_one :color
end
