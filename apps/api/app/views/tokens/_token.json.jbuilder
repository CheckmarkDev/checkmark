json.extract! token, :id, :token, :user, :created_at, :updated_at
json.url token_url(token, format: :json)
