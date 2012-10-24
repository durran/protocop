require "spec_helper"

describe Protocop::Fields::LengthBased do

  describe "#key" do

    let(:klass) do
      Class.new do
        include Protocop::Fields::LengthBased
      end
    end

    let(:field) do
      klass.new(1)
    end

    it "returns the integer for the number and the wire type" do
      expect(field.key).to eq(10)
    end
  end
end
