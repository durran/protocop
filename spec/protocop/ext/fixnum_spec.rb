require "spec_helper"

describe Fixnum do

  describe "::MAX_SIGNED_32BIT" do

    it "returns 2 ** 31 - 1" do
      expect(Fixnum::MAX_SIGNED_32BIT).to eq((2 ** 31) - 1)
    end
  end

  describe "::MAX_UNSIGNED_32BIT" do

    it "returns 2 ** 32 - 1" do
      expect(Fixnum::MAX_UNSIGNED_32BIT).to eq((2 ** 32) - 1)
    end
  end

  describe "::MAX_SIGNED_64BIT" do

    it "returns 2 ** 63 - 1" do
      expect(Fixnum::MAX_SIGNED_64BIT).to eq((2 ** 63) - 1)
    end
  end

  describe "::MAX_UNSIGNED_64BIT" do

    it "returns 2 ** 64 - 1" do
      expect(Fixnum::MAX_UNSIGNED_64BIT).to eq((2 ** 64) - 1)
    end
  end

  describe "::MIN_SIGNED_32BIT" do

    it "returns -(2 ** 31)" do
      expect(Fixnum::MIN_SIGNED_32BIT).to eq(-(2 ** 31))
    end
  end

  describe "::MIN_UNSIGNED_32BIT" do

    it "returns 0" do
      expect(Fixnum::MIN_UNSIGNED_32BIT).to be_zero
    end
  end

  describe "::MIN_SIGNED_64BIT" do

    it "returns -(2 ** 63)" do
      expect(Fixnum::MIN_SIGNED_64BIT).to eq(-(2 ** 63))
    end
  end

  describe "::MIN_UNSIGNED_64BIT" do

    it "returns 0" do
      expect(Fixnum::MIN_UNSIGNED_64BIT).to be_zero
    end
  end
end
