# frozen_string_literal: true

class TaskStreamingConsumer < ApplicationConsumer

  def consume
    messages.each do |message|
      payload = message.payload
      puts payload
      event_name = payload["event_name"]
      data = payload["data"]

      case event_name
      when "TaskCreated.V1"
        task = Task.create_with({
                                  fee: rand(10..20),
                                  price: rand(20..40),
                                }).
          find_or_initialize_by(public_id: data['public_id'])
        task.assign_attributes(description: data['description'], created_at: Time.at(data['created_at'] || Time.now.to_i))
        task.save!
      else
        puts "Unsupported event"
      end
    end
  end
end
