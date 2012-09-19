require "spec_helper"

describe Protocop::Fields::String do

  let(:field) do
    described_class.new
  end

  let(:outbound) do
    ""
  end

  describe "#encode" do

    context "when the string is empty" do

      before do
        field.encode(outbound, "")
      end

      it "encodes the length plus the string" do
        expect(outbound).to eq("\x00")
      end
    end

    context "when the string is nil" do

      before do
        field.encode(outbound, "")
      end

      it "encodes the length plus the string" do
        expect(outbound).to eq("\x00")
      end
    end

    context "when the string is not empty" do

      before do
        field.encode(outbound, "protocop")
      end

      it "encodes the length plus the string" do
        expect(outbound).to eq("\x08protocop")
      end
    end
  end
end
