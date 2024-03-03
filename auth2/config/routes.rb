Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :accounts, controllers: {
    registrations: 'accounts/registrations',
    sessions: 'accounts/sessions',
    # sign_out: 'accounts/sessions/sign_out'
  }

  root to: 'accounts#index'

  resources :accounts, only: [:edit, :update, :destroy, :sign_out]
  get '/accounts/current', to: 'accounts#current'
end
