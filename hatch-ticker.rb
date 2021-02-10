gem 'byebug', '=11.1.3'
require 'optparse'
require 'csv'
require 'yaml'
require 'byebug'
require_relative 'parse_orders.rb'
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

# file_name = "order-transaction-export-2021_02_05.csv"
file_name = ARGV[0]

raise "Filename must be provided" unless file_name

orders = CSV.parse(File.read(file_name), headers: true)
ticker_hash = ParseOrders.new(orders).call

puts ticker_hash.to_yaml
File.open("ticker.yaml", "w") { |file| file.write(ticker_hash.to_yaml) }
