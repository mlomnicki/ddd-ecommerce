module Sales
  module Domain
    DiscountApplied  = Event.new(:order_id, :amount)
    ItemAddedToOrder = Event.new(:order_id, :product_id, :price)
    OrderExpired     = Event.new(:order_id)
    OrderPlaced      = Event.new(:order_id, :customer_id, :total_price)

    PaymentSucceeded = Event.new(:payment_id, :order_id)
    PaymentFailed    = Event.new(:payment_id, :order_id)
  end
end
