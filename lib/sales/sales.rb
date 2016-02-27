module Sales
  OrderAlreadyPlaced = Class.new(StandardError)
  MissingOrderItems  = Class.new(StandardError)
  OrderNotPlaced     = Class.new(StandardError)
end

require_relative 'domain/order'
require_relative 'domain/product'
require_relative 'domain/events'
require_relative 'domain/payment_info'
require_relative 'application/order_application_service'
require_relative 'application/payment_application_service'
require_relative 'application/commands'
require_relative 'order_saga'
