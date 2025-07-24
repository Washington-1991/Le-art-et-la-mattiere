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
    resources :articles, only: [:index, :edit, :update, :destroy] # Añadido para gestión completa
  end
  get "/admin", to: "admin#index"
  get "admin_dashboard", to: "pages#admin_dashboard", as: :admin_dashboard

  # Carrito - Configuración optimizada
  resources :cart_items, only: [:create, :update, :destroy] do
    collection do
      delete 'clear', to: 'cart_items#clear' # Ruta opcional para vaciar el carrito
    end
  end

  resource :cart, only: [:show] do # Singular resource para el carrito
    member do
      get 'checkout', to: 'carts#checkout', as: :checkout # Ruta para el proceso de pago
    end
  end

  # PWA
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Páginas varias
  get "presentation", to: "pages#presentation"
  get "up" => "rails/health#show", as: :rails_health_check

  # Manejo de errores (opcional pero recomendado)
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
