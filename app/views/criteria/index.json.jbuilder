json.array!(@criteria) do |criterium|
  json.extract! criterium, :id
  json.url criterium_url(criterium, format: :json)
end
