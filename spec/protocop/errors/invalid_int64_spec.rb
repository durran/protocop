require "spec_helper"

describe Protocop::Errors::InvalidInt64 do

  describe "#message" do

    let(:error) do
      described_class.new(2 ** 65)
    end

    it "includes the provided value" do
      expect(error.message).to include((2 ** 65).to_s)
    end

    it "includes the valid min" do
      expect(error.message).to include(Integer::MIN_SIGNED_64BIT.to_s)
    end

    it "includes the valid max" do
      expect(error.message).to include(Integer::MAX_SIGNED_64BIT.to_s)
    end
  end
end
