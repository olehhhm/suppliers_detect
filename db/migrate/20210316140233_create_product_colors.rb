class CreateProductColors < ActiveRecord::Migration[5.2]
  def change
    create_table :product_colors do |t|
      t.references :product, index: true
      t.references :color, index: true
    end
  end
end
