require 'optparse'
require 'csv'
require 'yaml'
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
  lot_hash = {
    "symbol" => order["Instrument Code"],
    "quantity" => order["Quantity"].to_f,
    "unit_cost" => order["Price"].to_f
  }
  puts ticker_hash
  ticker_hash["watchlist"] << order["Instrument Code"]
  ticker_hash["lots"] << lot_hash
end

File.open("ticker.yaml", "w") { |file| file.write(ticker_hash.to_yaml) }
puts ticker_hash.to_yaml
