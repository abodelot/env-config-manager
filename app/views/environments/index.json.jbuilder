json.array!(@environments) do |directory|
  json.extract! directory, :id, :name, :ancestry
  json.url directory_url(directory, format: :json)
end
