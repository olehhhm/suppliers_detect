class SupplierDeliveryController < ApplicationController
  before_action :validate_params, only: [:info]

  def info
    basket_items = params[:basket][:items]

    # find all available supplier options for requested products
    records = SupplierInformation.by_region_and_products(params[:region], basket_items.map{|item| item[:product]})
    # find best supplier options
    options_finder = SupplierDelivery::OptionsFinder.new(basket_items, records)
    finder_result = options_finder.find_shipments_options(params[:max_supplier_combination])
    finder_result.freeze

    unless finder_result[:success]
      json_response(finder_result.slice(:success, :errors))
    else
      supplier_finder = SupplierDelivery::BestSupplierOptionFinder.new
      best_options = supplier_finder.choose_best_option(finder_result[:options])
      result_decorator = SupplierDelivery::Decorators::Base.new(finder_result[:options], best_options)
      json_response({success: true, result: result_decorator.result})
    end
  end

  private

  def validate_params
    params.require(:region)
    items = params.require(:basket).require(:items)
    raise ActionController::ParameterMissing.new(:items) unless items.is_a?(Array) && items.present?
    items.each{|item|
      item.require(:product)
      item.require(:count)
    }
  end
end