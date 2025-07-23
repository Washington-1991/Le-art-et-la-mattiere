Rails.application.routes.draw do
  # Root
  root to: "pages#home"  # ESTA ES LA CORRECTA
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

  # Cart
  resources :cart_items, only: [:create, :destroy]
  resource :cart, only: [:show]

  get "carts/show"  # Puedes considerar eliminar esta si ya usas resource :cart

  # PWA
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Misc
  get "presentation", to: "pages#presentation"
  get "up" => "rails/health#show", as: :rails_health_check
end
