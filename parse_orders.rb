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

    ticker_hash
  end
end
