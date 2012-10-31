require "spec_helper"

describe Protocop::Fields::String do

  let(:field) do
    described_class.new(:string, :test, 1)
  end

  let(:buffer) do
    Protocop::Buffer.new
  end

  describe "#encode" do

    context "when the string is empty" do

      let!(:written) do
        field.encode(buffer, "")
      end

      it "encodes the field, type and length plus the string" do
        expect(buffer.bytes).to eq("\n\x00")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the string is not empty" do

      let!(:written) do
        field.encode(buffer, "testing")
      end

      it "encodes the field, type and length plus the string" do
        expect(buffer.bytes).to eq("\n\x07testing")
      end

      it_behaves_like "a fluid interface"
    end
  end
end
