Rails.application.routes.draw do
  root to: "pages#home"
  get '/home', to: 'pages#home', as: :home

  # Articles
  get 'categories/:category', to: 'articles#category', as: :category_articles
  resources :articles

  # Users (Devise)
  devise_for :users
  resources :users, only: [:show]

  # Admin
  namespace :admin do
    resources :users
    resources :products
  end
  get "/admin", to: "admin#index"
  get "admin_dashboard", to: "pages#admin_dashboard", as: :admin_dashboard

  # Cart - Simplificado y mejorado
  resources :cart_items, only: [:create, :destroy]
  resource :cart, only: [:show]  # Esto crea cart_path (singular)

  # Elimina esta línea redundante:
  # get "carts/show"

  # PWA
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Misc
  get "presentation", to: "pages#presentation"
  get "up" => "rails/health#show", as: :rails_health_check
end
