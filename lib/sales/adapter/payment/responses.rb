module Sales
  module Adapter
    module Payment
      Success = Struct.new(:payment_id)
      Error   = Struct.new(:error_message)

      ApiFailure = Class.new(StandardError)
    end
  end
end
