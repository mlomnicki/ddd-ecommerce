module Sales
  module Domain
    DiscountApplied  = Event.new(:order_id, :amount)
    ItemAddedToOrder = Event.new(:order_id, :product_id, :price)
    OrderExpired     = Event.new(:order_id)
    OrderPlaced      = Event.new(:order_id, :customer_id, :total_price)
    OrderCompleted   = Event.new(:order_id)

    PaymentSucceeded = Event.new(:payment_id, :customer_id, :order_id, :amount)
    PaymentFailed    = Event.new(:error,      :customer_id, :order_id, :amount)
  end
end
