class SupplierInformation < ApplicationRecord
  belongs_to :product_information
  belongs_to :supplier
  has_many :supplier_region
end