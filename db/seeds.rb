# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
base_data = [
  {product_name: 'black_mug', supplier_name: 'Shirts4U', delivery_day_count: { "eu": 1, "us": 6, "uk": 2}, in_stock: 3},
  {product_name: 'blue_t-shirt', supplier_name: 'Best T-shirts', delivery_day_count: { "eu": 1, "us": 5, "uk": 2}, in_stock: 10},
  {product_name: 'white_mug', supplier_name: 'Shirts Unlimited', delivery_day_count: { "eu": 1, "us": 8, "uk": 2}, in_stock: 3},
  {product_name: 'black_mug', supplier_name: 'Shirts Unlimited', delivery_day_count: { "eu": 1, "us": 7, "uk": 2}, in_stock: 4},
  {product_name: 'pink_t-shirt', supplier_name: 'Shirts4U', delivery_day_count: { "eu": 2, "us": 6, "uk": 3}, in_stock: 8},
  {product_name: 'blue_t-shirt', supplier_name: 'Shirts4U', delivery_day_count: { "eu": 2, "us": 6, "uk": 3}, in_stock: 8},
  {product_name: 'pink_t-shirt', supplier_name: 'Best T-shirts', delivery_day_count: { "eu": 1, "us": 3, "uk": 2}, in_stock: 2},
  {product_name: 'white_hoodie', supplier_name: 'MyT-shirt', delivery_day_count: { "eu": 2, "us": 5, "uk": 1}, in_stock: 3},
]
base_data.each{ |data|
  product_color, product_name = data[:product_name].split('_')
  next if product_color.nil? || product_name.nil?
  ActiveRecord::Base.transaction do
    product = Product.find_or_create_by(name: product_name)
    color = Color.find_or_create_by(name: product_color)
    product_information = ProductInformation.find_or_create_by(product_id: product.id, color_id: color.id)
    supplier = Supplier.find_or_create_by(name: data[:supplier_name])

    supplier_information = SupplierInformation.create(supplier_id: supplier.id, product_information_id: product_information.id, in_stock_count: data[:in_stock])
    data[:delivery_day_count].each{|region_code, day_count|
      region = Region.find_or_create_by(code: region_code)
      supplier_region = SupplierRegion.create(supplier_information_id: supplier_information.id, region_id: region.id, delivery_day_count: day_count)
    }
  end
}