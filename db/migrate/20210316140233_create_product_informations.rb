class CreateProductInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :product_colors do |t|
      t.references :product, index: true
      t.references :colors, index: true
    end
  end
end
