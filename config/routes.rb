Rails.application.routes.draw do
  namespace :admin do
    get "orders/index"
    get "orders/show"
    get "orders/update"
    get "categories/index"
    get "categories/new"
    get "categories/create"
    get "categories/edit"
    get "categories/update"
    get "categories/destroy"
    get "products/index"
    get "products/new"
    get "products/create"
    get "products/edit"
    get "products/update"
    get "products/destroy"
    get "dashboard/index"
    resources :users
  end
  get "orders/show"
  get "orders/index"
  get "checkout/addresses"
  get "checkout/payment"
  get "checkout/confirm"
  get "cart_items/create"
  get "cart_items/update"
  get "cart_items/destroy"
  get "carts/show"
  get "catalog/index"
  get "catalog/show"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
