# frozen_string_literal: true

class TaskManagement
  class << self
    def assign_task(task)
      task.account_id = Account.enabled.ids.sample
      task.status ||= Task.statuses[:assigned]
    end

    def complete_task(task)
      task.finished_at = Time.now
    end

    def reassign_tasks
      tasks = Task.assigned
      tasks.each(&method(:assign_task))
      Task.import(tasks.to_a, on_duplicate_key_update: [:status, :account_id])
    end
  end
end
