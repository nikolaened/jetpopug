# frozen_string_literal: true

class TaskPriceSender
  def self.send_task_price(task)
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'billing-service',
      event_name: "TaskPriceSet",
      data: {
        public_id: task.public_id,
        task_price: task.price.to_s,
        task_fee: task.fee.to_s,
      }
    }
    if SchemaRegistry.validate_event(event.to_json, 'tasks.pricing.price_set').success?
      Karafka.producer.produce_sync(topic: 'task-pricing', payload: event.to_json)
    else
      StandardError.new("Event #{event[:event_id]} has invalid format")
    end
  end
end
