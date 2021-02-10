gem 'byebug', '=11.1.3'
require 'optparse'
require 'csv'
require 'yaml'
require 'byebug'
# @options = {}
# OptionParser.new do |opts|
#   puts opts
#   opts.on("-v", "--verbose", "Show extra information") do
#     @options[:verbose] = true
#   end
#   opts.on("-c", "--color", "Enable syntax highlighting") do
#     @options[:syntax_highlighting] = true
#   end
# end.parse!
# p @options

file_name = "order-transaction-export-2021_02_05.csv"

orders = CSV.parse(File.read(file_name), headers: true)

ticker_hash = { "watchlist" => [], "lots" => [] }

orders.each do |order|
  symbol = order["Instrument Code"]
  quantity = order["Quantity"].to_f
  unit_cost = order["Price"].to_f

  existing_lot = ticker_hash["lots"].find { |lot| lot["symbol"] == symbol } #remove it and add later?

  if existing_lot
    quantity += existing_lot["quantity"].to_f
    unit_cost = (unit_cost + existing_lot["unit_cost"].to_f) / 2.0
    ticker_hash["lots"].delete(existing_lot)
  end

  lot_hash = {
    "symbol" => symbol,
    "quantity" => quantity,
    "unit_cost" => unit_cost
  }
  ticker_hash["watchlist"] << order["Instrument Code"] unless existing_lot
  ticker_hash["lots"] << lot_hash
end

grouped_lots = ticker_hash["lots"].group_by { |lot| lot["symbol"] }
grouped_lots.each do |symbol, order|
end

File.open("ticker.yaml", "w") { |file| file.write(ticker_hash.to_yaml) }
puts ticker_hash.to_yaml
