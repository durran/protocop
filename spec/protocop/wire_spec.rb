require "spec_helper"

describe Protocop::Wire do

  describe "::VARINT" do

    it "returns 0" do
      expect(Protocop::Wire::VARINT).to eq(0)
    end
  end

  describe "::BIT64" do

    it "returns 1" do
      expect(Protocop::Wire::BIT64).to eq(1)
    end
  end

  describe "::LENGTH" do

    it "returns 2" do
      expect(Protocop::Wire::LENGTH).to eq(2)
    end
  end

  describe "::BIT32" do

    it "returns 5" do
      expect(Protocop::Wire::BIT32).to eq(5)
    end
  end
end
