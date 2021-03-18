class ProductInformation < ApplicationRecord
  belongs_to :product
  belongs_to :color
  has_many :supplier_information

  def color_name
    color.name
  end
  
  def product_name
    product.name
  end
end
