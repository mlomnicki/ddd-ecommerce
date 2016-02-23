module Sales
  module Adapter
    module Payment
      class Api
        attr_reader :requests, :response

        def initialize(response)
          @response = response
          @requests = []
        end

        def process_payment(payment_info)
          requests << payment_info
          if response.is_a?(Success)
            response
          else
            raise ApiFailure, response.error_message
          end
        end
      end
    end
  end
end
