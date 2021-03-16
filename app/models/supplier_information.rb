class SupplierInformation < ApplicationRecord
  belongs_to :product_information
  belongs_to :supplier
end