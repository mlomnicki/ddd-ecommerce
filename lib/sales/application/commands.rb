module Sales
  module Application
    AddItemToOrder = Command.new(:order_id, :product_id)
    PlaceOrder     = Command.new(:order_id, :customer_id)
    ExpireOrder    = Command.new(:order_id)
  end
end
