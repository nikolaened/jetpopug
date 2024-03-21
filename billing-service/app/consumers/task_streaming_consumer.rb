# frozen_string_literal: true

class TaskStreamingConsumer < ApplicationConsumer

  def consume
    messages.each do |message|
      payload = message.payload
      puts payload
      event_name = payload["event_name"]
      data = payload["data"]

      case event_name
      when "TaskCreated"
        with_validation(message, 'tasks.streaming.created') do
          task = Task.find_or_create_with_price(data['public_id'])
          task.assign_attributes(description: data['description'], created_at: Time.at(data['created_at'] || Time.now.to_i))
          task.save!

          event = {
            event_id: SecureRandom.uuid,
            event_version: 1,
            event_time: Time.now.to_s,
            producer: 'billing-service',
            event_name: "TaskPriceSet",
            data: {
              public_id: @task.public_id,
              task_price: @task.price.to_s,
              task_fee: @task.fee.to_s,
            }
          }
          if SchemaRegistry.validate_event(event.to_json, 'tasks.pricing.price_set').success?
            Karafka.producer.produce_sync(topic: 'task-pricing', payload: event.to_json)
          else
            raise StandardError.new("Event #{event[:event_id]} has invalid format")
          end
        end
      else
        handle_unprocessed(message)
      end
    end
  end
end
