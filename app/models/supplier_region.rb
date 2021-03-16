class SupplierRegion < ApplicationRecord
  belongs_to :supplier_information
  belongs_to :region
end
