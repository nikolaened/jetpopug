class BillingEventSender
  def self.send_event(account_public_id, credit: 0, debit: 0, type: "")
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'billing-service',
      event_name: "BalanceChanged",
      data: {
        account_public_id: account_public_id,
        credit: credit,
        debit: debit,
        type: type.presence
      }
    }
    if SchemaRegistry.validate_event(event.to_json, 'balances.changed').success?
      Karafka.producer.produce_sync(topic: 'balances', payload: event.to_json)
    else
      raise StandardError.new("Event #{event[:event_id]} has invalid format")
    end
  end
end