ENV['ACCOUNTS_API_ID'] = "LYwZ2h17ZZpqKent4euQQUe07czqCj1aljAoKEEQbdc"
ENV['ACCOUNTS_API_SECRET'] = "-bFLms_34vKdQ4zMmHjxlCSYH8uzuN39sNAFcHJjgF8"

OmniAuth.config.allowed_request_methods = [:get, :post]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :sso, ENV['ACCOUNTS_API_ID'], ENV['ACCOUNTS_API_SECRET'], scope: 'read'
end