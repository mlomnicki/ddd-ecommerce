module Sales
  module Domain
    module Order
      DiscountApplied = Event.new(:order_id, :amount)
    end
  end
end
