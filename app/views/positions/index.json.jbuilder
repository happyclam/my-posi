json.array!(@positions) do |position|
  json.extract! position, :id, :distinct, :sale, :exercise, :expiration, :maturity, :number, :unit
  json.url position_url(position, format: :json)
end
