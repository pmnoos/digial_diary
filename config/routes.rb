Rails.application.routes.draw do
  # Active Storage routes for file uploads
  
  get "demo_tour", to: "demo_tour#show"
  resources :subscriptions, only: [:index] do
    collection do
      get :pricing
      post :upgrade
      post :demo_mode
    end
  end

  resources :thoughts
  resources :events
  resources :checkout, only: [:create]

  resources :diary_entries do
    member do
      delete :remove_image
    end
    delete "image/:image_id", to: "diary_entries#purge_image", as: :image
  end

  devise_for :users, controllers: { sessions: 'sessions' }

  # Demo login route for instant access
  post "demo_login", to: "application#demo_login"

  # Plans and trial
  get "plans", to: "plans#index"
  get "plans/index"
  post "plans/start_trial", to: "plans#start_trial", as: :start_trial

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Archive
  get "archive", to: "diary_entries#archive"

  # Test routes removed - using simple textarea instead of Trix editor

  # Stripe webhook
  namespace :webhooks do
    post "stripe", to: "stripe#create"
  end

  # Image proxy for Trix editor
  get "image_proxy/:id", to: "image_proxy#show", as: :image_proxy
  get "image_proxy/:id/:variant", to: "image_proxy#show", as: :image_proxy_variant

  # Root path
  root "home#index"
end