module SupplierDelivery
  module Decorators
    class Base
      def initialize(options, best_options)
        @options = options
        @best_options = best_options
      end

      def result
        shipments_days = []
        shipments = group_by_shipments.map{|supplier, products|
          max_delivery_day_count = products.max_by{|product| product[:deliver_day_count]}[:deliver_day_count]
          shipments_days << max_delivery_day_count
          {
            supplier: supplier,
            delivery_date: max_delivery_day_count.days.from_now.strftime("%Y-%m-%d"),
            items: products.map{|product| { title: product[:title], count: product[:count] } }
          }
        }
        {
          delivery_date: shipments_days.max.days.from_now.strftime("%Y-%m-%d"),
          shipments: shipments
        }
      end

      private

      def group_by_shipments
        result = {}
        @options.each{|product_name, product_delivery_info|
          requsted_count = product_delivery_info[:requsted_count]
          @best_options[product_name][:supplier_info].each{|supplier_info|
            break unless requsted_count.positive?
            result[supplier_info.supplier.name] ||= []
            item = {title: product_name, count: 0, deliver_day_count: supplier_info.supplier_region.first.delivery_day_count}
            if supplier_info.in_stock_count >= requsted_count
              item[:count] = requsted_count
              requsted_count = 0
            else
              item[:count] = supplier_info.in_stock_count
              requsted_count = requsted_count - supplier_info.in_stock_count
            end
            result[supplier_info.supplier.name] << item
          }
        }
        result
      end
    end
  end
end
