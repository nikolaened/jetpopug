json.extract! task, :id, :description, :status, :finished_at, :account_id, :created_at, :updated_at, :jira_id
json.url task_url(task, format: :json)
