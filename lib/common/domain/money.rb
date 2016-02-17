require 'bigdecimal'

module Common
  module Domain
    Money = Struct.new(:amount_in_cents, :currency) do
      DEFAULT_CURRENCY = "EUR".freeze

      def self.from_float(amount)
        new((amount * 100).round, DEFAULT_CURRENCY)
      end

      private_class_method :new

      alias_method :to_i, :amount_in_cents

      def to_s
        sprintf("%.2f", amount)
      end
    end
  end
end
