class CreateSupplierInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :supplier_informations do |t|
      t.references :product, index: true
      t.references :supplier, index: true
      t.integer :in_stock_count, :null => false
    end
  end
end
