module Sales
  module Adapter
    Success = Struct.new(:payment_id)
    Error   = Struct.new(:error_message)
  end
end
