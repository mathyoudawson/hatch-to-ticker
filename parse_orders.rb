class ParseOrders
  def initialize(orders)
    @orders = orders
  end

  def call
    buy_orders = @orders.select { |order| order["Transaction Type"] == "BUY" }

    ticker_hash = { "watchlist" => [], "lots" => [] }

    buy_orders.each do |order|
      symbol = order["Instrument Code"]
      quantity = order["Quantity"].to_f
      unit_cost = order["Price"].to_f

      lot_hash = {
        "symbol" => symbol,
        "quantity" => quantity,
        "unit_cost" => unit_cost
      }

      ticker_hash["watchlist"] << order["Instrument Code"]
      ticker_hash["lots"] << lot_hash
    end

    ticker_hash
  end
end
