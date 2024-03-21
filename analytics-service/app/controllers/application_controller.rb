class ApplicationController < ActionController::Base
  def login_required
    if !current_account
      respond_to do |format|
        format.html  {
          redirect_to '/auth/sso'
        }
        format.json {
          render :json => { 'error' => 'Access Denied' }.to_json
        }
      end
    end
  end

  def current_account
    return nil unless session[:account_id]
    @current_account ||= Account.find_by_public_id(session[:account_id])
  end
end
