json.array!(@strategies) do |strategy|
  json.extract! strategy, :id, :name, :draw_type, :range, :interest, :sigma
  json.url strategy_url(strategy, format: :json)
end
