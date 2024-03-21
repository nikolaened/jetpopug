# frozen_string_literal: true

class TaskWorkflowConsumer < ApplicationConsumer

  def consume
    messages.each do |message|
      payload = message.payload
      puts payload
      event_name = payload["event_name"]
      data = payload["data"]

      case event_name
      when "TaskAdded"
        account = Account.find_by_public_id(data['public_id'])
        if account.blank?
          puts "No associated account #{data['public_id']}"
        else
          task = Task.find_or_create_with_price(data['public_id'])
          task.assign_attributes(account_id: account.id)
          task.save!
          SimpleBillingLogic.create_deposit_transaction(account, task.fee, task.public_id)
        end
      when "TaskAssigned"
        account = Account.find_by_public_id(data['assignee_public_id'])
        if account.blank?
          puts "No associated account #{data['public_id']}"
        else
          task = Task.find_or_create_with_price(data['public_id'])
          task.assign_attributes(account_id: account.id)
          task.save!
          SimpleBillingLogic.create_deposit_transaction(account, task.fee, task.public_id)
        end
      when "TaskCompleted"
        account = Account.find_by_public_id(data['last_assignee_public_id'])
        if account.blank?
          puts "No associated account #{data['public_id']}"
        else
          task = Task.find_or_create_with_price(data['public_id'])
          SimpleBillingLogic.create_payment_transaction(account, task.price, task.public_id)
        end
      else
        puts "Unsupported event"
      end
    end
  end
end
