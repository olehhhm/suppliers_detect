class ProductInformation < ApplicationRecord
  belongs_to :product
  belongs_to :color
  has_many :supplier_information
end
