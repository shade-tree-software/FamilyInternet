json.extract! user, :id, :name, :active, :countdown, :created_at, :updated_at
json.url user_url(user, format: :json)
