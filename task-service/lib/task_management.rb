# frozen_string_literal: true

class TaskManagement
  class << self
    def assign_task(task)
      task.account_id = Account.ids.sample
    end

    def complete_task(task)
      task.finished_at = Time.now
    end
  end
end
