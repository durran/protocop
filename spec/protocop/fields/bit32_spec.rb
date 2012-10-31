require "spec_helper"

describe Protocop::Fields::Bit32 do

  describe "#key" do

    let(:klass) do
      Class.new do
        include Protocop::Fields::Bit32
      end
    end

    let(:field) do
      klass.new(:bit32, :test, 1)
    end

    it "returns the integer for the number and the wire type" do
      expect(field.key).to eq(13)
    end
  end
end
