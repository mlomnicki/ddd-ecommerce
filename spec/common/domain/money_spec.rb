require 'spec_helper'

RSpec.describe Common::Domain::Money do
  it "can be created from a float value" do
    money = described_class.from_float(14.50)
    expect(money.amount_in_cents).to eq(1450)
  end

  it "can be created from an int value" do
    money = described_class.from_int(1450)
    expect(money.amount_in_cents).to eq(1450)
  end

  it "cannot be created using constructor" do
    expect { described_class.new(123) }.to raise_error(NoMethodError)
  end

  describe "an instance" do
    let(:money) { described_class.from_float(14.99) }

    it "returns a formatted value" do
      expect(money.to_s).to eq("EUR14.99")
    end

    it "converts to int" do
      expect(money.to_i).to eq(1499)
    end
  end

  describe "calculation" do
    let(:price) { described_class.from_float(14.99) }
    let(:tax)   { described_class.from_float(2.45) }

    it "adds two values" do
      expected_value = described_class.from_float(17.44)
      expect(price + tax).to eq(expected_value)
    end

    it "subtracts one value from another" do
      expected_value = described_class.from_float(12.54)
      expect(price - tax).to eq(expected_value)
    end
  end
end
