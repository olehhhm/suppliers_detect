module SupplierDelivery
  class BestSupplierOptionFinder
    # it's finding most preferred supplier combination which will contains min count them
    # return best options for each product
    def choose_best_option options
      suppliers_weight = calculate_supplier_weight(options)
      best_option = {}
      options.each{|product_name, product_delivery_option|
        best_option[product_name] = choose_supplier_by_weight(suppliers_weight, product_delivery_option) 
      }
      best_option
    end

    def choose_supplier_by_weight(supplier_weight, option)
      delivery_options_by_weight = option[:delivery_options].max_by{|delivery_option|
        suppliers = delivery_option[:supplier_info].map{|info| info.supplier.name}
        if suppliers.length == 1
          supplier_weight[suppliers.first]
        else
          suppliers = suppliers.uniq
          max_intersecting_supplier_with_multi = suppliers.max_by{|supplier| supplier_weight[supplier]}
          # because combination of suppliers is always in less priority
          supplier_weight[max_intersecting_supplier_with_multi] - 1
        end
      }
      suppliers = delivery_options_by_weight[:supplier_info].map{|info| info.supplier.name}.uniq
      # if we already take some supplier we need to up him priority
      suppliers.each{|supplier| supplier_weight[supplier] += 1}
      delivery_options_by_weight
    end

    # calculate supplier weight by count of intersection between different products
    # one supplier match it's one weight unit if supplier is not in combination with other suppliers
    # when it's combination supplier weight counting like "1 - (combination size without this supplier)"
    def calculate_supplier_weight(options)
      suppliers_weight = {}
      # calculate supplier intersection between different options and product for founding the most combination
      options.each{|product_name, product_delivery_option|
        product_delivery_option[:delivery_options].each{|delivery_option|
          suppliers = delivery_option[:supplier_info].map{|info| info.supplier.name}
          if suppliers.length == 1
            suppliers_weight[suppliers.first] ||= 0
            suppliers_weight[suppliers.first] += 1
          else
            suppliers = suppliers.uniq
            suppliers.uniq.each{|supplier|
            suppliers_weight[supplier] ||= 0
              # because combination of supplier is always in less priority 
              suppliers_weight[supplier] += 1 - (suppliers.length - 1)
            }
          end
        }
      }
      suppliers_weight
    end
  end
end
