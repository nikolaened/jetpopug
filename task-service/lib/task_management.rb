# frozen_string_literal: true

class TaskManagement
  class << self

    def create_task(task)
      assign_task(task)
    end

    def complete_task(task)
      task.finished_at = Time.now
    end

    def reassign_tasks
      tasks = Task.assigned
      events = []
      tasks.each do |task|
        assign_task(task)
        if task.account_id_changed?
          event = {
            event_name: "TaskAssigned.V1",
            data: {
              task_public_id: task.public_id,
              assignee_public_id: task.account.public_id,
              created_at: task.created_at.to_i
            }
          }
          events << event
        end
      end
      Task.import(tasks.to_a, on_duplicate_key_update: [:status, :account_id])
      Karafka.producer.produce_many_sync(events.map { |event| { topic: 'task-workflow', payload: event.to_json } })
    end

    private

    def assign_task(task)
      task.account_id = Account.enabled.ids.sample
      task.status ||= Task.statuses[:assigned]
    end
  end
end
