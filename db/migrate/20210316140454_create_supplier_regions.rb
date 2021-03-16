class CreateSupplierRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :supplier_regions do |t|
      t.references :supplier, index: true
      t.references :region, index: true
      t.integer :delivery_day_count, :null => false
    end
  end
end
