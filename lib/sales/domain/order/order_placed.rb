module Sales
  module Domain
    module Order
      OrderPlaced = Common::Event.new(:order_id, :customer_id, :total_price)
    end
  end
end
