json.extract! task, :id, :account_id, :public_id, :fee, :price, :description, :created_at, :updated_at
json.url task_url(task, format: :json)
