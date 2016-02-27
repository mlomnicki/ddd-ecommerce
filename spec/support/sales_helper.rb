require 'sales/adapter/persistence/order_repository'
require 'sales/adapter/persistence/order_saga_repository'
require 'sales/adapter/persistence/product_repository'
require 'sales/adapter/payment/gateway'
require 'sales/adapter/payment/api'

module SalesHelper
  def order_id
    1
  end

  def customer_id
    15
  end

  def payment_id
    "49ce25fa-3a09-477a-874b-3ef919f0b727"
  end

  def amount
    Money.from_float(25.99)
  end

  def product
    Sales::Domain::Product.new(1, "Implementing DDD", amount)
  end
end
