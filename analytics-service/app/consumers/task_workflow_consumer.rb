# frozen_string_literal: true

class TaskWorkflowConsumer < ApplicationConsumer

  def consume
    messages.each do |message|
      payload = message.payload
      event_name = payload["event_name"]
      event_version = payload["event_version"]
      data = payload["data"]

      case [event_name, event_version]
      when ["TaskAdded", 1], ["TaskAdded", nil]
        account = Account.find_by_public_id(data['assignee_public_id'])
        if account.blank?
          puts "No associated account #{data['assignee_public_id']}"
        else
          task = Task.find_or_create_by(data['public_id'])
          AssigneeLogService.task_created_for(task, account)
        end
      when ["TaskAssigned", 1], ["TaskAssigned", nil]
        account = Account.find_by_public_id(data['assignee_public_id'])
        if account.blank?
          puts "No associated account #{data['assignee_public_id']}"
        else
          task = Task.find_or_create_by(data['public_id'])
          AssigneeLogService.task_assigned_to(task, account)
        end
      when ["TaskCompleted", 1], ["TaskCompleted", nil]
        account = Account.find_by_public_id(data['last_assignee_public_id'])
        if account.blank?
          puts "No associated account #{data['last_assignee_public_id']}"
        else
          task = Task.find_or_create_by(data['public_id'])
          AssigneeLogService.task_completed_by(task, account)
        end
      else
        handle_unprocessed(message)
      end
    end
  end
end
