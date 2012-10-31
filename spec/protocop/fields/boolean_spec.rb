require "spec_helper"

describe Protocop::Fields::Boolean do

  let(:field) do
    described_class.new(:boolean, :test, 1)
  end

  let(:buffer) do
    Protocop::Buffer.new
  end

  describe "#encode" do

    context "when provided true" do

      let!(:written) do
        field.encode(buffer, true)
      end

      it "encodes the field, type and integer" do
        expect(buffer.bytes).to eq("\x08\x01")
      end

      it_behaves_like "a fluid interface"
    end

    context "when provided false" do

      let!(:written) do
        field.encode(buffer, false)
      end

      it "encodes the field, type and integer" do
        expect(buffer.bytes).to eq("\x08\x00")
      end

      it_behaves_like "a fluid interface"
    end
  end
end
