class Product < ApplicationRecord
  has_many :product_informations, dependent: :destroy
end
