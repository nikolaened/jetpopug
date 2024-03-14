ENV['ACCOUNTS_API_ID'] = "ZhJ1IcwLwqh4nITimCQsrHPfx3dH9zweByKQuiml6zM"
ENV['ACCOUNTS_API_SECRET'] = "VfoA5ZCVqz9h7k7kvdo5oZNPuqg-NF92VIIWEAlYSmY"

OmniAuth.config.allowed_request_methods = [:get, :post]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :sso, ENV['ACCOUNTS_API_ID'], ENV['ACCOUNTS_API_SECRET'], scope: 'read'
end