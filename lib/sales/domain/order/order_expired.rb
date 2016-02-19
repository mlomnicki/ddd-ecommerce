module Sales
  module Domain
    module Order
      OrderExpired = Common::Event.new(:order_id)
    end
  end
end
