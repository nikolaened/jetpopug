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
        Account.transaction do
          account = account_relation.create!(data)
          Balance.create!(account: account)
        end
      when "AccountUpdated"
        account_relation.find_or_initialize_by(public_id: data["public_id"]).update!(data.slice(*Account::ALLOWED_UPDATE_ATTRIBUTES))
      when "AccountDeleted"
        account_relation.find_by_public_id(data["public_id"]).update!(active: false, disabled_at: data["disabled_at"])
      else
        puts "Unsupported event"
      end
    end
  end

  def account_relation
    Account.create_with(password: "#{SecureRandom.hex}123")
  end
end
