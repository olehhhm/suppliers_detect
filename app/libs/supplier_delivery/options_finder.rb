module SupplierDelivery
  class OptionsFinder
    DEFAULT_COMBINATION_LIMIT = 3

    ERRORS = {
      not_find_available_shipments: "Can't find shipment for product $$product_name",
      out_of_stock: "Sorry but product $$product_name is out of stock",
      default: "Product is invalid"
    }
    
    def initialize(requested_items, supplier_information_records)
      @requested_items = requested_items
      @supplier_information = supplier_information_records
    end

    # findind all possible shipments options.
    # it's checking if supplier has count of product in stock
    # it's finding the most faster in delivery options
    # combination_limit - defining how many suppliers combination is allowed
    def find_shipments_options(combination_limit = nil)
      combination_limit ||= DEFAULT_COMBINATION_LIMIT
      result = {success: true, errors: [], options: {}}
      records = group_by_name_and_color
      @requested_items.each{ |product|
        name, color = SupplierInformation.parse_name(product[:product])
        unless records[name].present?
          result[:success] = false
          result[:errors] << error(product, :not_find_available_shipments)
          next
        end
        if color.present? && !records[name][color].present?
          result[:success] = false
          result[:errors] << error(product, :not_find_available_shipments)
          next
        end

        # if color is not exist it's will take all possible product by name and ignore their colors
        supplier_info = color.nil? ? records[name].values.flatten : records[name][color]
        valid_suppliers = find_most_faster_supplier_options(product, supplier_info, combination_limit)
        
        if valid_suppliers.length.zero?
          result[:success] = false
          result[:errors] << error(product, :out_of_stock)
          next
        end

        result[:options][product[:product]] = valid_suppliers.min_by{|supp| supp[:delivery_day_count]}
        result[:options][product[:product]][:requsted_count] = product[:count]
      }
      result
    end

    private

    def error item, error_code
      error_text = ERRORS[error_code] || ERRORS[:default]
      error_text = error_text.gsub("$$product_name", item[:product])
      error_text
    end

    # finding most faster single supplier or combination of it who can provide us needed count of product
    def find_most_faster_supplier_options(product, supplier_info, combination_limit)
      valid_suppliers = []
      (1..combination_limit).to_a.each{|combination_count|
        combinations = supplier_info.combination(combination_count).to_a.map{|comb|
          {
            supplier_info: comb,
            stock_sum: comb.sum{|one| one.in_stock_count},
            delivery_day_count_max: comb.map{|one| one.supplier_region.first.delivery_day_count}.max,
          }
        }
        who_have_needed_count = combinations.select{|comb| comb[:stock_sum] >= product[:count]}
        next if who_have_needed_count.length.zero?
        
        # all supplier who can provide us requested count of product by min delivery day count
        min_day = who_have_needed_count.group_by{|comb| comb[:delivery_day_count_max]}.min_by{|key, value| key.to_i}
        valid_suppliers << {
          delivery_day_count: min_day[0],
          delivery_options: min_day[1]
        }
      }
      valid_suppliers
    end

    def group_by_name_and_color
      records = @supplier_information.group_by{|record| record.product_information.product.name}
      records.each{|key, record|
        records[key] = record.group_by{|record| record.product_information.color.name}
      }
      records
    end
  end
end
