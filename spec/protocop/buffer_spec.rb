require "spec_helper"

describe Protocop::Buffer do

  describe "#initialize" do

    let(:buffer) do
      described_class.new
    end

    it "sets the bytes to an empty string" do
      expect(buffer.bytes).to eq("")
    end

    it "forces the string encoding to binary" do
      expect(buffer.bytes.encoding.name).to eq("ASCII-8BIT")
    end
  end

  describe "#write_string" do

    let(:buffer) do
      described_class.new
    end

    context "when the string is empty" do

      let(:written) do
        buffer.write_string("")
      end

      it "does not add anything to the buffer" do
        expect(written.bytes).to eq("")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the string is nil" do

      let(:written) do
        buffer.write_string(nil)
      end

      it "does not add anything to the buffer" do
        expect(written.bytes).to eq("")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the string is not empty" do

      let(:written) do
        buffer.write_string("test")
      end

      it "adds the string to the buffer" do
        expect(written.bytes).to eq("test")
      end

      it_behaves_like "a fluid interface"
    end
  end

  describe "#write_varint64" do

    let(:buffer) do
      described_class.new
    end

    context "when provided a 1 byte integer" do

      let(:written) do
        buffer.write_varint64(5)
      end

      it "adds the string to the buffer" do
        expect(written.bytes).to eq("\x05")
      end

      it_behaves_like "a fluid interface"
    end

    context "when provided a 2 byte integer" do

      let(:written) do
        buffer.write_varint64(130)
      end

      it "adds the string to the buffer" do
        expect(written.bytes).to eq("\x82\x01")
      end

      it_behaves_like "a fluid interface"
    end

    context "when provided a 3 byte integer" do

      let(:written) do
        buffer.write_varint64(20400)
      end

      it "adds the string to the buffer" do
        expect(written.bytes).to eq("\xB0\x9F\x01")
      end

      it_behaves_like "a fluid interface"
    end
  end
end
