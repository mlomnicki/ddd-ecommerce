module Sales
  module Domain
    class Product
      attr_reader :id, :name, :price

      def initialize(id, name, price)
        @id    = id
        @name  = name
        @price = price
      end
    end
  end
end
