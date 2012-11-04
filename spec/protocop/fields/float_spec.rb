require "spec_helper"

describe Protocop::Fields::Float do

  let(:buffer) do
    Protocop::Buffer.new
  end

  describe "#encode" do

    context "when the field is not repeated" do

      let(:field) do
        described_class.new(:float, :test, 1)
      end

      let!(:written) do
        field.encode(buffer, 10.345)
      end

      it "encodes the field, type and float" do
        expect(buffer.bytes).to eq("\r\x1F\x85%A")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the field is repeated" do

      let(:field) do
        described_class.new(:float, :test, 1, repeated: true)
      end

      let!(:written) do
        field.encode(buffer, [ 10.345, 1.1 ])
      end

      it "encodes the field, type and float" do
        expect(buffer.bytes).to eq("\r\x1F\x85%A\r\xCD\xCC\x8C?")
      end

      it_behaves_like "a fluid interface"
    end
  end
end
