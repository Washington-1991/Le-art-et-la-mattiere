# config/routes.rb
Rails.application.routes.draw do
  root "pages#home"
  get '/home', to: 'pages#home'

  resources :articles
  devise_for :users
  resources :users, only: [:show]

  namespace :admin do
    resources :users
    resources :products
    resources :articles, only: [:index, :edit, :update, :destroy]
  end
  get "/admin", to: "admin#index"
  get "admin_dashboard", to: "pages#admin_dashboard"

  resources :cart_items, only: [:create, :update, :destroy] do
    collection { delete 'clear', to: 'cart_items#clear' }
  end

  # Carrito como recurso singular, con acción extra de checkout
  resource :cart, only: [:show] do
    get :checkout, on: :member
  end

  # Otras rutas...
  get "presentation", to: "pages#presentation"
  get "up", to: "rails/health#show"
  get "service-worker", to: "rails/pwa#service_worker"
  get "manifest", to: "rails/pwa#manifest"

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
