module SalesHelper
  def order_id
    1
  end

  def customer_id
    15
  end

  def product
    Sales::Domain::ProductCatalog::Product.new(
      1,
      "Implementing DDD",
      Money.from_float(25.99)
    )
  end
end
