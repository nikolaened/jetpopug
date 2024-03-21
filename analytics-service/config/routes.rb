Rails.application.routes.draw do
  resources :tasks, only: [:index, :show]
  devise_for :accounts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "tasks#index"

  # omniauth
  get '/auth/:provider/callback' => 'accounts#create'
  get '/auth/failure' => 'accounts#failure'

  # Custom logout
  get '/logout', :to => 'accounts#destroy'
end
