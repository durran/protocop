require "spec_helper"

describe Protocop::Buffer do

  let(:buffer) do
    described_class.new
  end

  describe "#initialize" do

    it "sets the bytes to an empty string" do
      expect(buffer.bytes).to eq("")
    end

    it "forces the string encoding to binary" do
      expect(buffer.bytes.encoding.name).to eq("ASCII-8BIT")
    end
  end

  describe "#write_boolean" do

    context "when the boolean is true" do

      let(:written) do
        buffer.write_boolean(true)
      end

      it "adds the boolean to the buffer" do
        expect(written.bytes).to eq("\x01")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the boolean is false" do

      let(:written) do
        buffer.write_boolean(false)
      end

      it "adds the boolean to the buffer" do
        expect(written.bytes).to eq("\x00")
      end

      it_behaves_like "a fluid interface"
    end
  end

  pending "#write_enum"
  pending "#write_int32"
  pending "#write_int64"
  pending "#write_uint32"
  pending "#write_sint32"
  pending "#write_sint64"

  pending "#write_fixed64"
  pending "#write_sfixed64"
  pending "#write_double"

  pending "#write_bytes"
  pending "#write_embedded"
  pending "#write_repeated"

  pending "#write_fixed32"
  pending "#write_sfixed32"
  pending "#write_float"

  describe "#write_string" do

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

  describe "#write_uint64" do

    context "when provided a 1 byte integer" do

      let(:written) do
        buffer.write_uint64(5)
      end

      it "adds the string to the buffer" do
        expect(written.bytes).to eq("\x05")
      end

      it_behaves_like "a fluid interface"
    end

    context "when provided a 2 byte integer" do

      let(:written) do
        buffer.write_uint64(130)
      end

      it "adds the string to the buffer" do
        expect(written.bytes).to eq("\x82\x01")
      end

      it_behaves_like "a fluid interface"
    end

    context "when provided a 3 byte integer" do

      let(:written) do
        buffer.write_uint64(20400)
      end

      it "adds the string to the buffer" do
        expect(written.bytes).to eq("\xB0\x9F\x01")
      end

      it_behaves_like "a fluid interface"
    end
  end
end
