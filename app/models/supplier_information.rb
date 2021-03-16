class SupplierInformation < ApplicationRecord
  has_one :product
  has_one :supplier
end