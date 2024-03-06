ENV['ACCOUNTS_API_ID'] = "ABqRc_zAnFrjXkPdIhjw8itMfDSlTj3MXTzE0fnJBLE"
ENV['ACCOUNTS_API_SECRET'] = "97wy4fDUQTxIcaIuPPFP2P7F1Szk3b3BUgcJ-3kjZds"

OmniAuth.config.allowed_request_methods = [:get, :post]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :sso, ENV['ACCOUNTS_API_ID'], ENV['ACCOUNTS_API_SECRET'], scope: 'read'
end