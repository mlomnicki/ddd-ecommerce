class ValueObject < Struct
  def self.new(*attributes, &block)
    super.tap do |struct_class|
      struct_class.class_eval <<-RUBY
        def initialize(#{attributes.map { |attr| "#{attr}:" }.join(', ')})
          super(#{attributes.join(', ')})
        end
      RUBY
    end
  end
end
