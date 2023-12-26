json.extract! user, :id, :nome, :sobrenome, :created_at, :updated_at
json.url user_url(user, format: :json)
