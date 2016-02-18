module Sales
  module Domain
    module ProductCatalog
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
end
