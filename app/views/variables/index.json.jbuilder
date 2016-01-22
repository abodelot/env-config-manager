json.array!(@variables) do |variable|
  json.extract! variable, :id, :key, :value, :directory_id
  json.url variable_url(variable, format: :json)
end
