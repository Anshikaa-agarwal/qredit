Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root "home_feed#index"

  namespace :admin do
    root "dashboard#index"

    resources :users, only: %i[ index show ]
    resources :questions, only: %i[ index show ]
  end

  resources :users, only: [ :show ] do
    get "followers_list", to: "users#followers"
    patch :update_profile, on: :member
    resources :topic_assignements, only: [ :create, :destroy ]
    resources :followers, only: %i[ create destroy ]
  end

  concern :votable do
    resources :votes, only: [ :create, :destroy ]
  end

  concern :reportable do
    resources :abuses, only: [ :create ]
  end

  resources :questions, param: :url, concerns: [ :votable, :reportable ] do
    resources :answers, concerns: [ :votable, :reportable ] do
      resources :comments, concerns: [ :votable, :reportable ]
    end
    resources :comments, concerns: [ :votable, :reportable ]
    patch :publish, on: :member
  end

  get :credits, to: "users#credits"
  resources :credit_purchases, only: [ :new, :create, :show ] do
    get :success, on: :collection
  end
  resources :stripe_checkouts, only: [ :create ]
  post "/stripe/webhooks", to: "stripe_webhooks#create"


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
