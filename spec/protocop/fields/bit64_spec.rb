require "spec_helper"

describe Protocop::Fields::Bit64 do

  describe "#key" do

    let(:klass) do
      Class.new do
        include Protocop::Fields::Bit64
      end
    end

    let(:field) do
      klass.new(1)
    end

    it "returns the integer for the number and the wire type" do
      expect(field.key).to eq(9)
    end
  end
end
