class Supplier < ApplicationRecord
  has_many :supplier_informations, dependent: :destroy
end
