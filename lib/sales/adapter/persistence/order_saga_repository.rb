require_relative 'abstract_repository'

module Sales
  module Adapter
    module Persistence
      class OrderSagaRepository < AbstractRepository
        def aggregate_class
          Domain::OrderSaga
        end
      end
    end
  end
end
