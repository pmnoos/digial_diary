Rails.application.routes.draw do
  resources :subscriptions, only: [:index] do
    collection do
      get :pricing
      post :upgrade
      post :demo_mode
    end
  end
  resources :thoughts
  resources :diary_entries do
    member do
      delete :remove_image
    end
  end
  devise_for :users, controllers: { sessions: 'sessions' }
  
  # Demo login route for instant access
  post "demo_login", to: "application#demo_login"
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "archive", to: "diary_entries#archive"

   # Defines the root path route ("/")
   root "home#index"
   
   # Test route for rich text editor
   get "test_editor", to: "home#test_editor"
end
