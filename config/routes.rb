Rails.application.routes.draw do
  # ======================
  # 🔐 Devise Authentication
  # ======================
  devise_for :users

  # ======================
  # 🧭 Admin Namespace
  # ======================
  namespace :admin do
    # Dashboard
    get "dashboard", to: "dashboard#index"

    # Admin management resources
    resources :users
    resources :categories
    resources :products

    # Orders (admin can see all + manage)
    resources :orders, only: [:index, :show, :update, :destroy]
  end

  # ======================
  # 🛍️ Storefront Routes (API)
  # ======================

  post   "login",  to: "auth#login"
  delete "logout", to: "auth#logout"
  get    "me",     to: "auth#me"
  # Public product catalog (uses ProductsController with STI filter ?type=ring)
  resources :products, only: [:index, :show]
  get "/search/suggestions", to: "products#suggestions"
  get "/search/popular", to: "products#popular"

  # Cart (guest + user)
  # CartsController: index, show, create (add to cart), update, destroy, current_cart
  resources :carts, only: [:index, :show, :create, :update, :destroy]
  get "/cart", to: "carts#current"  # returns current cart for guest/user

  # Cart items (if you have a CartItemsController; if not, you can remove this)
  resources :cart_items, only: [:create, :update, :destroy]

  # Orders (client-facing)
  # OrdersController: index, show, create, update, verify_otp
  resources :orders, only: [:index, :show, :create, :update] do
    post "verify_otp", on: :member
  end

  resource :wishlist, only: [:show] do
    post   :add_item
    delete "remove_item/:variant_id", action: :remove_item, as: :remove_item
  end

  # ======================
  # (Optional) Checkout Wizard Pages
  # ======================
  # Only keep this if you actually have `Checkout::AddressesController`, etc.
  namespace :checkout do
    get "addresses"
    get "payment"
    get "confirm"
  end

  # ======================
  # 💎 Product Types (STI)
  # ======================
  # You **do not need** separate resources for rings/necklaces/etc.
  # You can filter by /products?type=ring using ProductsController.
  #
  # Remove these unless you actually have RingsController, BraceletsController...
  #
  # resources :rings
  # resources :bracelets
  # resources :necklaces
  # resources :earrings
  # resources :watches
  # resources :accessories

  # ======================
  # 🩺 Health check
  # ======================
  get "up" => "rails/health#show", as: :rails_health_check

  # ======================
  # 🏠 Root Route
  # ======================
  # Use ProductsController#index as main catalog page
  root "products#index"
end
