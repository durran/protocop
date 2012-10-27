require "spec_helper"

describe Protocop::Errors::InvalidUint64 do

  describe "#message" do

    let(:error) do
      described_class.new(-10)
    end

    it "includes the provided value" do
      expect(error.message).to include("-10")
    end

    it "includes the valid min" do
      expect(error.message).to include(Integer::MIN_UNSIGNED_64BIT.to_s)
    end

    it "includes the valid max" do
      expect(error.message).to include(Integer::MAX_UNSIGNED_64BIT.to_s)
    end
  end
end
