Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :articles

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Nueva ruta para /presentation
  get "presentation", to: "pages#presentation"
end
