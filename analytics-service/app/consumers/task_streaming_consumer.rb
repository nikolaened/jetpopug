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
        end
      else
        handle_unprocessed(message)
      end
    end
  end
end
