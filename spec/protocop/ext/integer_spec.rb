require "spec_helper"

describe Integer do

  describe "::MAX_SIGNED_32BIT" do

    it "returns 2 ** 31 - 1" do
      expect(Integer::MAX_SIGNED_32BIT).to eq((2 ** 31) - 1)
    end
  end

  describe "::MAX_UNSIGNED_32BIT" do

    it "returns 2 ** 32 - 1" do
      expect(Integer::MAX_UNSIGNED_32BIT).to eq((2 ** 32) - 1)
    end
  end

  describe "::MAX_SIGNED_64BIT" do

    it "returns 2 ** 63 - 1" do
      expect(Integer::MAX_SIGNED_64BIT).to eq((2 ** 63) - 1)
    end
  end

  describe "::MAX_UNSIGNED_64BIT" do

    it "returns 2 ** 64 - 1" do
      expect(Integer::MAX_UNSIGNED_64BIT).to eq((2 ** 64) - 1)
    end
  end

  describe "::MIN_SIGNED_32BIT" do

    it "returns -(2 ** 31)" do
      expect(Integer::MIN_SIGNED_32BIT).to eq(-(2 ** 31))
    end
  end

  describe "::MIN_UNSIGNED_32BIT" do

    it "returns 0" do
      expect(Integer::MIN_UNSIGNED_32BIT).to be_zero
    end
  end

  describe "::MIN_SIGNED_64BIT" do

    it "returns -(2 ** 63)" do
      expect(Integer::MIN_SIGNED_64BIT).to eq(-(2 ** 63))
    end
  end

  describe "::MIN_UNSIGNED_64BIT" do

    it "returns 0" do
      expect(Integer::MIN_UNSIGNED_64BIT).to be_zero
    end
  end

  describe "#int32?" do

    context "when the integer is in range" do

      it "returns true" do
        expect(1024).to be_int32
      end
    end

    context "when the integer is not in range" do

      it "returns false" do
        expect(2 ** 34).not_to be_int32
      end
    end

    context "when the integer is exactly the minimum" do

      it "returns true" do
        expect(Integer::MIN_SIGNED_32BIT).to be_int32
      end
    end

    context "when the integer is exactly the maximum" do

      it "returns true" do
        expect(Integer::MAX_SIGNED_32BIT).to be_int32
      end
    end
  end

  describe "#int64?" do

    context "when the integer is in range" do

      it "returns true" do
        expect(1024).to be_int64
      end
    end

    context "when the integer is not in range" do

      it "returns false" do
        expect(2 ** 65).not_to be_int64
      end
    end

    context "when the integer is exactly the minimum" do

      it "returns true" do
        expect(Integer::MIN_SIGNED_64BIT).to be_int64
      end
    end

    context "when the integer is exactly the maximum" do

      it "returns true" do
        expect(Integer::MAX_SIGNED_64BIT).to be_int64
      end
    end
  end

  describe "#uint32?" do

    context "when the integer is in range" do

      it "returns true" do
        expect(1024).to be_uint32
      end
    end

    context "when the integer is not in range" do

      it "returns false" do
        expect(-16).not_to be_uint32
      end
    end

    context "when the integer is exactly the minimum" do

      it "returns true" do
        expect(Integer::MIN_UNSIGNED_32BIT).to be_uint32
      end
    end

    context "when the integer is exactly the maximum" do

      it "returns true" do
        expect(Integer::MAX_UNSIGNED_32BIT).to be_uint32
      end
    end
  end

  describe "#uint64?" do

    context "when the integer is in range" do

      it "returns true" do
        expect(1024).to be_uint64
      end
    end

    context "when the integer is not in range" do

      it "returns false" do
        expect(2 ** 65).not_to be_uint64
      end
    end

    context "when the integer is exactly the minimum" do

      it "returns true" do
        expect(Integer::MIN_UNSIGNED_64BIT).to be_uint64
      end
    end

    context "when the integer is exactly the maximum" do

      it "returns true" do
        expect(Integer::MAX_UNSIGNED_64BIT).to be_uint64
      end
    end
  end
end
