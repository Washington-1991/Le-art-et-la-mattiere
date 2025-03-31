Rails.application.routes.draw do
  # root to home
  root to: "pages#home"  # Agrega esto nuevamente
  get '/home', to: 'pages#home', as: :home

  # Articles routes
  resources :articles

  # Users routes
  devise_for :users

  resources :users, only: [:show]  # Solo permite `show` para todos
  resources :users, only: [:index, :new, :create, :edit, :update, :destroy], constraints: lambda { |request| request.env["warden"].authenticate? && request.env["warden"].user.admin? }

  root "home#index"  # O la página principal de tu app


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # New route for /presentation
  get "presentation", to: "pages#presentation"
end
