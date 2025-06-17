Rails.application.routes.draw do
  get "carts/show"
  # Root to home
  root to: "pages#home"  # ESTA ES LA CORRECTA
  get '/home', to: 'pages#home', as: :home

  # Articles routes
  # Rutas por categoría de artículos
  get 'categories/:category', to: 'articles#category', as: :category_articles
  resources :articles


  # Users routes
  devise_for :users

  # Admin routes
  namespace :admin do
    get "users/index"
    get "users/new"
    get "users/edit"
    resources :products
  end
  get "/admin", to: "admin#index"

  resources :users, only: [:show]

  # Cart routes
  resource :cart, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]


  # Rutas para administradores (añadida ruta del dashboard)
  namespace :admin do
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  get "admin_dashboard", to: "pages#admin_dashboard", as: :admin_dashboard

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA files
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # New route for /presentation
  get "presentation", to: "pages#presentation"
end
