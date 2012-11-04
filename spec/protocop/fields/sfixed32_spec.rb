require "spec_helper"

describe Protocop::Fields::Sfixed32 do

  let(:buffer) do
    Protocop::Buffer.new
  end

  describe "#encode" do

    context "when the field is not repeated" do

      let(:field) do
        described_class.new(:sfixed32, :test, 1)
      end

      let!(:written) do
        field.encode(buffer, 150)
      end

      it "encodes the field, type and integer" do
        expect(buffer.bytes).to eq("\r,\x01\x00\x00")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the field is repeated" do

      let(:field) do
        described_class.new(:sfixed32, :test, 1, repeated: true)
      end

      let!(:written) do
        field.encode(buffer, [ 150, 1 ])
      end

      it "encodes the field, type and integer" do
        expect(buffer.bytes).to eq("\r,\x01\x00\x00\r\x02\x00\x00\x00")
      end

      it_behaves_like "a fluid interface"
    end
  end
end
