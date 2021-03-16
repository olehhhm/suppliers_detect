class ProductInformation < ApplicationRecord
  has_one :product
  has_one :color
end
