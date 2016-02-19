module Sales
  module Domain
    module Order
      DiscountApplied = Common::Event.new(:order_id, :amount)
    end
  end
end
