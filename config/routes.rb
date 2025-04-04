Rails.application.routes.draw do
  # Root to home
  root to: "pages#home"  # ESTA ES LA CORRECTA
  get '/home', to: 'pages#home', as: :home

  # Articles routes
  resources :articles

  # Users routes
  devise_for :users

  # Admin routes
  namespace :admin do
    resources :products
  end
  get "/admin", to: "admin#index"

  resources :users, only: [:show]  # Solo permite `show` para todos

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
