# frozen_string_literal: true

# Example consumer that prints messages payloads
class AccountStreamingConsumer < ApplicationConsumer

  def consume
    messages.each do |message|
      payload = message.payload
      event_name = payload["event_name"]
      event_version = payload["event_version"]
      data = payload["data"]

      case [event_name, event_version]
      when ["AccountCreated", 1], ["AccountCreated", nil]
        with_validation(payload.to_json, 'accounts.created') { account_relation.create!(data) }
      when ["AccountUpdated", 1], ["AccountUpdated", nil]
        with_validation(payload.to_json, 'accounts.updated') do
          account_relation.find_or_initialize_by(public_id: data["public_id"]).update!(data.slice(*Account::ALLOWED_UPDATE_ATTRIBUTES))
        end
      when ["AccountDeleted", 1], ["AccountDeleted", nil]
        with_validation(payload.to_json, 'accounts.deleted') do
          account_relation.find_by_public_id(data["public_id"]).update!(active: false, disabled_at: data["disabled_at"])
        end
      else
        puts "Unsupported event"
      end
    end
  end

  def account_relation
    Account.create_with(password: "#{SecureRandom.hex}123")
  end
end
