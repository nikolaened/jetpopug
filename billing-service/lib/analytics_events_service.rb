# frozen_string_literal: true

class AnalyticsEventsService
  def self.share_current_balances
    Account.all.each do |account|
      balance_entity = account.balance

      event = {
        event_id: SecureRandom.uuid,
        event_version: 1,
        event_time: Time.now.to_s,
        producer: 'billing-service',
        event_name: "BalanceSnapshotTaken",
        data: {
          account_public_id: account.public_id,
          balance: balance_entity.balance,
          date: Date.current.to_s,
        }
      }
      if SchemaRegistry.validate_event(event.to_json, 'balances.snapshot_taken').success?
        Karafka.producer.produce_sync(topic: 'balances', payload: event.to_json)
      else
        raise StandardError.new("Event #{event[:event_id]} has invalid format")
      end
    end
  end
end
