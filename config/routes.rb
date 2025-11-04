Rails.application.routes.draw do
  # Active Storage routes for file uploads
  
  get "demo_tour", to: "demo_tour#show"
  resources :subscriptions, only: [:index] do
   collection do
    get   :pricing
    patch :change_plan
    post  :cancel
    post  :resume
    post  :demo_mode
    post  :upgrade 
  end
end

  resources :thoughts
  resources :events
  resources :checkout, only: [:create]

  resources :diary_entries do
    member do
      delete :remove_image
      delete 'image/:image_id', to: 'diary_entries#destroy_image', as: :image
    end
  end
 resources :reminders, only: [:index] do
    member do
      patch :dismiss
      patch :snooze
    end
  end

   resources :subscriptions, only: [:index] do
    collection do
      patch :change_plan     # change_plan_subscriptions_path(plan: 'monthly'|'yearly')
      post  :cancel          # cancel_subscriptions_path
      post  :resume          # resume_subscriptions_path (optional)
    end
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
  root "diary_entries#index"
  get "home", to: "home#index"
  get "features", to: "pages#landing"

 end
  

