Rails.application.routes.draw do
  # Página principal
  root to: "pages#home"
  get '/home', to: 'pages#home', as: :home

  # Articles
  get 'categories/:category', to: 'articles#category', as: :category_articles
  resources :articles

  # Usuarios (Devise)
  devise_for :users
  resources :users, only: [:show]

  # Admin
  namespace :admin do
    resources :users
    resources :products
  end
  get "/admin", to: "admin#index"
  get "admin_dashboard", to: "pages#admin_dashboard", as: :admin_dashboard

  # Carrito
  resources :cart_items, only: [:create, :update, :destroy]  # <- se añadió :update aquí
  resource :cart, only: [:show]  # singular porque cada usuario tiene un solo carrito

  # PWA
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Páginas varias
  get "presentation", to: "pages#presentation"
  get "up" => "rails/health#show", as: :rails_health_check
end
