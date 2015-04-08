json.array!(@categories) do |category|
  json.extract! category, :id, :tab_name, :value, :operation
  json.url category_url(category, format: :json)
end
