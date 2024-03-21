require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Sso < OmniAuth::Strategies::OAuth2
      CUSTOM_PROVIDER_URL = 'http://127.0.0.1:3000'

      option :name, :sso

      option :client_options, {
        :site => CUSTOM_PROVIDER_URL,
        :authorize_url => "#{CUSTOM_PROVIDER_URL}/oauth/authorize",
        :access_token_url => "#{CUSTOM_PROVIDER_URL}/oauth/token"
      }

      uid { raw_info["public_id"] }

      info do
        {
          :email => raw_info["email"],
          :full_name => raw_info["full_name"],
          :position => raw_info["position"],
          :active => raw_info["active"],
          :role => raw_info["role"],
          :public_id => raw_info["public_id"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/accounts/current').parsed
      end
    end
  end
end
