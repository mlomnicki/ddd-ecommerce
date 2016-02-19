module Sales
  module Domain
    module Order
      OrderExpired = Event.new(:order_id)
    end
  end
end
