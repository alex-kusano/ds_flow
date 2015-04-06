json.array!(@rule_sets) do |rule_set|
  json.extract! rule_set, :id
  json.url rule_set_url(rule_set, format: :json)
end
