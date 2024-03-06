class AccountsController < ApplicationController
  before_action :login_required, only: [ :destroy ]

  def create
    omniauth = request.env['omniauth.auth']

    account = Account.find_by_public_id(omniauth['uid'])
    unless account
      # New account registration (if got before account streaming)
      account = Account.new(public_id: omniauth['uid'])
    end
    account.email = omniauth.info.email
    account.full_name = omniauth.info.full_name
    account.role = omniauth.info.role
    account.position = omniauth.info.position
    account.active = omniauth.info.active
    account.password = "#{SecureRandom.hex}#{rand(100)}"

    account.save!

    if account.save
      # Currently storing all the info
      session[:account_id] = account.public_id

      flash[:notice] = "Successfully logged in"
      redirect_to root_path
    else
      flash[:notice] = "Something went wrong"
      redirect_to failure
    end
  end

  # Omniauth failure callback
  def failure
    flash[:notice] = params[:message]
  end

  # logout - Clear our rack session BUT essentially redirect to the provider
  # to clean up the Devise session from there too !
  def destroy
    session[:account_id] = nil

    flash[:notice] = 'You have successfully signed out!'
    redirect_to "http://127.0.0.1:3000/accounts/sign_out"
  end
end