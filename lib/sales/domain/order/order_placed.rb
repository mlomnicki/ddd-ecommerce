module Sales
  module Domain
    module Order
      class OrderPlaced < Common::Event
        attribute :order_id,    Types::Int
        attribute :customer_id, Types::Int
      end
    end
  end
end
