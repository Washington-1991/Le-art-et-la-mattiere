Rails.application.routes.draw do
  # root to home
  root to: "pages#home"  # Agrega esto nuevamente
  get '/home', to: 'pages#home', as: :home

  # Articles routes
  resources :articles

  # Users routes
  devise_for :users
  get '/profile', to: 'users#show', as: :profile
  resources :users, only: [:index, :show]
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # New route for /presentation
  get "presentation", to: "pages#presentation"
end
