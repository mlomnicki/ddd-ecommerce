module Sales
  module Domain
    DiscountApplied  = Event.new(:order_id, :amount)
    ItemAddedToOrder = Event.new(:order_id, :product_id, :price)
    OrderExpired     = Event.new(:order_id)
    OrderPlaced      = Event.new(:order_id, :customer_id, :total_price)
  end
end
