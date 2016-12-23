Rails.application.routes.draw do

  get 'domains/show'

  namespace :admin do
    get 'domains/destroy'
  end

  get "set_language/update"
  post "/rate" => "rater#create", :as => "rate"
  devise_for :admins, path: "admin",
    controllers: {sessions: "admin/sessions"}
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

  root "static_pages#home"
  mount ActionCable.server => "/cable"
  namespace :admin do
    root "home#index", path: "/"
    resources :orders, only: [:index, :show, :destroy]
    resources :shop_requests, only: [:index, :update]
    resources :categories
    resources :users
    resources :products, only: :index
    resources :set_user, only: :create
    resources :shops, except: [:new, :create, :show]
    resources :user_domains, only: [:new, :destroy]
  end

  namespace :dashboard do
    root "statistics#index", path: "/"
    resources :shops do
      resources :products
      resources :orders
      resources :shop_managers, only: [:index, :create, :destroy]
      resources :order_managers, only: :index
      resources :order_products
      resources :accepted_order_products, defaults: {format: "json"}
    end
    resources :statistics
  end

  resources :domains, only: :show
  match "/", to: "static_pages#home", constraints: { subdomain: "www" }, via: [:get, :post, :put, :patch, :delete]
  resources :shops, only: [:index, :show, :update]
  resources :products, only: [:index, :show, :new] do
    resources :comments, only: :create
  end
  resources :comments, only: :destroy
  resources :carts
  resources :orders
  resource :orders
  resources :users, only: :show
  resources :events, only: [:index, :update] do
    post :read_all, on: :collection
  end
  resources :categories do
    resources :products
  end
  resources :tags, only: :show
  get "search(/:search)", to: "searches#index", as: :search
end
