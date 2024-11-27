namespace :api do
  namespace :v1 do
    scope :users do
      post "/", to: "users/registrations#create", as: :user_registration
      # post "/applications", to: "users/applications#create", as: :user_application
    end
    resources :documents, only: [ :index, :show, :create ]
  end
end

scope :api do
  scope :v1 do
    use_doorkeeper do
      skip_controllers :authorization, :authorized_applications
    end
  end
end
