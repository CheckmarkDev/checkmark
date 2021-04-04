json.extract! task, :id, :content, :type, :user, :created_at, :updated_at
json.url task_url(task, format: :json)
