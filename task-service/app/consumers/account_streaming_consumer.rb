# frozen_string_literal: true

# Example consumer that prints messages payloads
class AccountStreamingConsumer < ApplicationConsumer

  def consume
    messages.each do |message|
      payload = message.payload
      event_name = payload["event_name"]
      data = payload["data"]

      case event_name
      when "AccountCreated"
        Account.create!(data.merge(password: "#{SecureRandom.hex}123"))
      when "AccountUpdated"
        Account.find_by_public_id(data["public_id"]).update!(data.slice(*Account::ALLOWED_UPDATE_ATTRIBUTES))
      when "AccountDeactivated"
        Account.find_by_public_id(data["public_id"]).update!(active: false, disabled_at: data["disabled_at"])
      else
        puts "Unsupported event"
      end
    end
  end

  # Run anything upon partition being revoked
  # def revoked
  # end

  # Define here any teardown things you want when Karafka server stops
  # def shutdown
  # end
end
