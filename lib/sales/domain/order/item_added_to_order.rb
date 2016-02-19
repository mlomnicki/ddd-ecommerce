module Sales
  module Domain
    module Order
      ItemAddedToOrder = Event.new(:order_id, :product_id, :price)
    end
  end
end
