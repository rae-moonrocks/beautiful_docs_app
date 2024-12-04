Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "site_pages#home"

  draw :api

  resources :documents, only: [ :index, :show ]

  get :terms, to: "site_pages#terms"
  get :getting_started, to: "site_pages#getting_started"
  get :contact, to: "site_pages#contact"

  namespace :users do
    # get "/applications", to: "applications#new"
    # post "/applications", to: "applications#create"
    # get "/applications/:id", to: "applications#show"
    resources :applications, only: [ :new, :create, :show, :index ]
    post "/applications/:id/refresh_token", to: "applications#refresh_token", as: :refresh_token
  end
end
