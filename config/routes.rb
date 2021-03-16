Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/supplier_delivery', to: 'supplier_delivery#info'
end
