class SupplierInformation < ApplicationRecord
  has_one :product_information
  has_one :supplier
end