# frozen_string_literal: true

class TaskWorkflowConsumer < ApplicationConsumer

  def consume
    messages.each do |message|
      payload = message.payload
      puts payload
      event_name = payload["event_name"]
      data = payload["data"]

      case event_name
      when "TaskCreated"
        account = Account.find_by_public_id(data['public_id'])
        if account.blank?
          puts "No associated account #{data['public_id']}"
        else
          task = Task.create_with({
                                    fee: rand(10..20),
                                    price: rand(20..40),
                                  }).
            find_or_initialize_by(public_id: data['public_id'])
          task.assign_attributes(account_id: account.id)
          task.save!
          # create_deposit_transaction
        end
      when "TaskAssigned"
        account = Account.find_by_public_id(data['assignee_public_id'])
        if account.blank?
          puts "No associated account #{data['public_id']}"
        else
          task = Task.create_with({
                                    fee: rand(10..20),
                                    price: rand(20..40),
                                  }).
            find_or_initialize_by(public_id: data['public_id'])
          task.assign_attributes(account_id: account.id)
          task.save!
          # create_deposit_transaction
        end
      when "TaskCompleted"
        account = Account.find_by_public_id(data['last_assignee_public_id'])
        if account.blank?
          puts "No associated account #{data['public_id']}"
        else
          task = Task.create_with({
                                    fee: rand(10..20),
                                    price: rand(20..40),
                                  }).
          find_or_initialize_by(public_id: data['public_id'])
          # create payment transaction
        end
      else
        puts "Unsupported event"
      end
    end
  end
end
