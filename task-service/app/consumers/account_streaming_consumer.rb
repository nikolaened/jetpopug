# frozen_string_literal: true

# Example consumer that prints messages payloads
class AccountStreamingConsumer < ApplicationConsumer

  def consume
    messages.each do |message|
      payload = message.payload
      Rails.logger.info(payload)
      event_name = payload["event_name"]
      event_version = payload["event_version"]
      data = payload["data"]

      case [event_name, event_version]
      when ["AccountCreated", 1], ["AccountCreated", nil]
        with_validation(payload.to_json, 'accounts.created') { Account.create!(data.merge(password: "#{SecureRandom.hex}123")) }
      when ["AccountUpdated", 1], ["AccountUpdated", nil]
        with_validation(payload.to_json, 'accounts.updated') { Account.find_by_public_id(data["public_id"]).update!(data.slice(*Account::ALLOWED_UPDATE_ATTRIBUTES)) }
      when ["AccountDeleted", 1], ["AccountDeleted", nil]
        with_validation(payload.to_json, 'accounts.deleted') { Account.find_by_public_id(data["public_id"]).update!(active: false, disabled_at: data["disabled_at"]) }
      else
        handle_unprocessed(payload)
      end
    end
  end

  def with_validation(event, type, version: 1, &block)
    if SchemaRegistry.validate_event(event, type, version: version).success?
      block.call
    else
      handle_unprocessed(event)
    end
  end

  def handle_unprocessed(event)
    puts "Unsupported event"
    UnprocessedEvent.create!(raw_event: event)
  end
end
