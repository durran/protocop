require "spec_helper"

describe Protocop::Fields::String do

  let(:field) do
    described_class.new(1)
  end

  let(:outbound) do
    Protocop::Buffer.new
  end

  describe "#encode" do

    context "when the string is empty" do

      before do
        field.encode(outbound, "")
      end

      it "encodes the length plus the string" do
        expect(outbound.bytes).to eq("\n\x00")
      end
    end

    context "when the string is nil" do

      before do
        field.encode(outbound, "")
      end

      it "encodes the length plus the string" do
        expect(outbound.bytes).to eq("\n\x00")
      end
    end

    context "when the string is not empty" do

      before do
        field.encode(outbound, "testing")
      end

      it "encodes the length plus the string" do
        expect(outbound.bytes).to eq("\n\x07testing")
      end
    end
  end
end
