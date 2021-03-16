class SupplierRegion < ApplicationRecord
  belongs_to :supplier
  belongs_to :region
end
