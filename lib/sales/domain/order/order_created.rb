module Sales
  module Domain
    module Order
      class OrderCreated < Dry::Data::Value
        attribute :order_id,    Types::Int
        attribute :customer_id, Types::Int
      end
    end
  end
end
