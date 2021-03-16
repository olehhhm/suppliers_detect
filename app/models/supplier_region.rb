class SupplierRegion < ApplicationRecord
  belongs_to :supplier
  has_one :region
end
