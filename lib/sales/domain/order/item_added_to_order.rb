module Sales
  module Domain
    module Order
      class ItemAddedToOrder < Common::Event
        attribute :order_id,   Types::Int
        attribute :product_id, Types::Int
        attribute :price,      Types::Int
      end
    end
  end
end
