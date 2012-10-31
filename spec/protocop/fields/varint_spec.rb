require "spec_helper"

describe Protocop::Fields::Varint do

  describe "#key" do

    let(:klass) do
      Class.new do
        include Protocop::Fields::Varint
      end
    end

    let(:field) do
      klass.new(:varint, :test, 1)
    end

    it "returns the integer for the number and the wire type" do
      expect(field.key).to eq(8)
    end
  end
end
