module Sales
  module Domain
    module Order
      class ItemAddedToOrder < Dry::Data::Value
        attribute :order_id,   Types::Int
        attribute :product_id, Types::Int
      end
    end
  end
end
