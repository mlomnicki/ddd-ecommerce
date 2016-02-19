require 'bigdecimal'

module Common
  module Domain
    Money = Struct.new(:amount_in_cents, :currency) do
      DEFAULT_CURRENCY = "EUR".freeze

      def self.from_float(amount, currency = DEFAULT_CURRENCY)
        new((amount * 100).round, currency)
      end

      def self.from_int(amount, currency = DEFAULT_CURRENCY)
        new(amount, currency)
      end

      def self.zero
        from_int(0)
      end

      private_class_method :new

      alias_method :to_i, :amount_in_cents

      def +(other)
        plus(other.amount_in_cents)
      end

      def -(other)
        plus(-other.amount_in_cents)
      end

      def to_s
        sprintf("#{currency}%.2f", amount_in_cents / 100.0)
      end

      private

      def plus(added_amount_in_cents)
        self.class.from_int(amount_in_cents + added_amount_in_cents, currency)
      end
    end
  end
end
