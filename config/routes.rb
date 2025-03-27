Rails.application.routes.draw do

  root to: "pages#home"

  # articulos
  resources :articles

  # usuarios

  devise_for :users
  resources :users, only: [:show]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Nueva ruta para /presentation
  get "presentation", to: "pages#presentation"
end
