class Product < ApplicationRecord
  has_many :product_color, dependent: :destroy
end
