json.extract! task, :id, :description, :status, :finished_at, :account_id, :created_at, :updated_at
json.url task_url(task, format: :json)
