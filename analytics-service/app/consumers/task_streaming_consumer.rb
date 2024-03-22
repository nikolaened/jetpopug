# frozen_string_literal: true

class TaskStreamingConsumer < ApplicationConsumer

  def consume
    messages.each do |message|
      payload = message.payload
      event_name = payload["event_name"]
      event_version = payload["event_version"]
      data = payload["data"]

      case [event_name, event_version]
      when ["TaskCreated", 1], ["TaskCreated", nil]
        with_validation(message, 'tasks.streaming.created') do
          task = Task.find_or_create_with_price(data['public_id'])
          task.assign_attributes(description: data['description'], created_at: Time.at(data['created_at'] || Time.now.to_i))
          task.save!

          TaskPriceSender.send_task_price(@task)
        end
      when ["TaskCreated", 2]
        with_validation(message, 'tasks.streaming.created', version: 2) do
          task = Task.find_or_create_with_price(data['public_id'])
          task.assign_attributes(description: data['description'],
                                 jira_id: data['jira_id'],
                                 created_at: Time.at(data['created_at'] || Time.now.to_i))
          task.save!

          TaskPriceSender.send_task_price(@task)
        end
      else
        handle_unprocessed(message)
      end
    end
  end
end
