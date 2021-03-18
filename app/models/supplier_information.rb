class SupplierInformation < ApplicationRecord
  belongs_to :product_information
  belongs_to :supplier
  has_many :supplier_region

  scope :by_region_and_products, -> (region, product_names) {
    condition, values = build_product_condition product_names
    includes({supplier_region: [:region]})
      .includes({product_information: [:product, :color]})
      .where({regions: {code: region}})
      .where(condition.join(" OR "), *values)
      .order("supplier_regions.delivery_day_count ASC")
  }

  
  def self.parse_name name
    color, name = name.split('_')
    # when product have only name, without color
    if name.nil?
      name = color 
      color = nil
    end
    [name, color]
  end

  
  def self.build_product_condition product_names
    condition = []
    values = []
    product_names.each{|product|
      name, color = parse_name(product)

      where = "products.name = ?"
      values << name
      unless color.nil?
        where << " AND colors.name = ?"
        values << color
      end
      condition << where
    }
    [condition, values]
  end

end