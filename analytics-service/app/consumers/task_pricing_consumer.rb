# frozen_string_literal: true

class TaskWorkflowConsumer < ApplicationConsumer

  def consume
    messages.each do |message|
      payload = message.payload
      event_name = payload["event_name"]
      event_version = payload["event_version"]
      data = payload["data"]

      case [event_name, event_version]
      when ["TaskPriceSet", 1], ["TaskPriceSet", nil]
        Task.find_or_create_by!(data['public_id']).update!(price: data['task_price'], fee: data['task_fee'])
      else
        handle_unprocessed(message)
      end
    end
  end
end
