require "spec_helper"

describe Protocop::Buffer do

  let(:buffer) do
    described_class.new
  end

  pending "#write_enum"
  pending "#write_embedded"
  pending "#write_repeated"

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

  describe "#write_bytes" do

    let(:written) do
      buffer.write_bytes("\x04\x01")
    end

    it "adds the bytes to the buffer" do
      expect(written.bytes).to eq("\x04\x01")
    end

    it_behaves_like "a fluid interface"
  end

  describe "#write_double" do

    let(:written) do
      buffer.write_double(1.21)
    end

    let(:expected) do
      [ 1.21 ].pack("E")
    end

    it "adds the double to the buffer" do
      expect(written.bytes).to eq(expected)
    end

    it_behaves_like "a fluid interface"
  end

  describe "#write_fixed32" do

    let(:written) do
      buffer.write_fixed32(1000)
    end

    it "adds the int to the buffer" do
      expect(written.bytes).to eq("\xE8\x03\x00\x00")
    end

    it_behaves_like "a fluid interface"

    context "when the value is greater than 32 bit" do

      it "raises an error" do
        expect {
          buffer.write_fixed32(2 ** 34)
        }.to raise_error(Protocop::Errors::InvalidInt32)
      end
    end
  end

  describe "#write_fixed64" do

    let(:written) do
      buffer.write_fixed64(1000)
    end

    let(:value) do
      [ 1000 & 0xFFFFFFFF, 1000 >> 32 ].pack("VV")
    end

    it "adds the int to the buffer" do
      expect(written.bytes).to eq(value)
    end

    it_behaves_like "a fluid interface"

    context "when the value is greater than 64 bit" do

      it "raises an error" do
        expect {
          buffer.write_fixed64(2 ** 65)
        }.to raise_error(Protocop::Errors::InvalidInt64)
      end
    end
  end

  describe "#write_float" do

    let(:written) do
      buffer.write_float(1.21)
    end

    let(:expected) do
      [ 1.21 ].pack("e")
    end

    it "adds the float to the buffer" do
      expect(written.bytes).to eq(expected)
    end

    it_behaves_like "a fluid interface"
  end

  describe "#write_int32" do

    context "when the value is 32 bit" do

      let(:written) do
        buffer.write_int32(12)
      end

      it "adds the int to the buffer" do
        expect(written.bytes).to eq("\f")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the value is greater than 32 bit" do

      it "raises an error" do
        expect {
          buffer.write_int32(2 ** 34)
        }.to raise_error(Protocop::Errors::InvalidInt32)
      end
    end
  end

  describe "#write_int64" do

    let(:written) do
      buffer.write_int64(1000)
    end

    it "adds the int to the buffer" do
      expect(written.bytes).to eq("\xE8\a")
    end

    it_behaves_like "a fluid interface"

    context "when the value is greater than 64 bit" do

      it "raises an error" do
        expect {
          buffer.write_int64(2 ** 65)
        }.to raise_error(Protocop::Errors::InvalidInt64)
      end
    end
  end

  describe "#write_sfixed32" do

    let(:written) do
      buffer.write_sfixed32(1000)
    end

    let(:converted) do
      (1000 << 1) ^ (1000 >> 31)
    end

    let(:value) do
      [ converted ].pack("V")
    end

    it "adds the int to the buffer" do
      expect(written.bytes).to eq(value)
    end

    it_behaves_like "a fluid interface"

    context "when the value is greater than 32 bit" do

      it "raises an error" do
        expect {
          buffer.write_sfixed32(2 ** 34)
        }.to raise_error(Protocop::Errors::InvalidInt32)
      end
    end
  end

  describe "#write_sfixed64" do

    let(:written) do
      buffer.write_sfixed64(1000)
    end

    let(:converted) do
      (1000 << 1) ^ (1000 >> 63)
    end

    let(:value) do
      [ converted & 0xFFFFFFFF, converted >> 32 ].pack("VV")
    end

    it "adds the int to the buffer" do
      expect(written.bytes).to eq(value)
    end

    it_behaves_like "a fluid interface"

    context "when the value is greater than 64 bit" do

      it "raises an error" do
        expect {
          buffer.write_sfixed64(2 ** 65)
        }.to raise_error(Protocop::Errors::InvalidInt64)
      end
    end
  end

  describe "#write_sint32" do

    context "when the value is 32 bit" do

      let(:written) do
        buffer.write_sint32(10)
      end

      it "adds the int to the buffer" do
        expect(written.bytes).to eq("\x14")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the value is greater than 32 bit" do

      it "raises an error" do
        expect {
          buffer.write_sint32(2 ** 34)
        }.to raise_error(Protocop::Errors::InvalidInt32)
      end
    end
  end

  describe "#write_sint64" do

    let(:written) do
      buffer.write_sint64(1000)
    end

    it "adds the int to the buffer" do
      expect(written.bytes).to eq("\xD0\x0F")
    end

    it_behaves_like "a fluid interface"

    context "when the value is greater than 64 bit" do

      it "raises an error" do
        expect {
          buffer.write_sint64(2 ** 65)
        }.to raise_error(Protocop::Errors::InvalidInt64)
      end
    end
  end

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

  describe "#write_uint32" do

    context "when the value is 32 bit" do

      let(:written) do
        buffer.write_uint32(10)
      end

      it "adds the int to the buffer" do
        expect(written.bytes).to eq("\n")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the value is negative" do

      it "raises an error" do
        expect {
          buffer.write_uint32(-10)
        }.to raise_error(Protocop::Errors::InvalidUint32)
      end
    end

    context "when the value is greater than 32bit" do

      it "raises an error" do
        expect {
          buffer.write_uint32(2 ** 40)
        }.to raise_error(Protocop::Errors::InvalidUint32)
      end
    end
  end

  describe "#write_uint64" do

    context "when the value is 64 bit" do

      let(:written) do
        buffer.write_uint64(10)
      end

      it "adds the int to the buffer" do
        expect(written.bytes).to eq("\n")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the value is negative" do

      it "raises an error" do
        expect {
          buffer.write_uint64(-10)
        }.to raise_error(Protocop::Errors::InvalidUint64)
      end
    end

    context "when the value is greater than 64bit" do

      it "raises an error" do
        expect {
          buffer.write_uint64(2 ** 70)
        }.to raise_error(Protocop::Errors::InvalidUint64)
      end
    end
  end

  describe "#write_varint" do

    context "when provided a 1 byte integer" do

      let(:written) do
        buffer.write_varint(5)
      end

      it "adds the string to the buffer" do
        expect(written.bytes).to eq("\x05")
      end

      it_behaves_like "a fluid interface"
    end

    context "when provided a 2 byte integer" do

      let(:written) do
        buffer.write_varint(130)
      end

      it "adds the string to the buffer" do
        expect(written.bytes).to eq("\x82\x01")
      end

      it_behaves_like "a fluid interface"
    end

    context "when provided a 3 byte integer" do

      let(:written) do
        buffer.write_varint(20400)
      end

      it "adds the string to the buffer" do
        expect(written.bytes).to eq("\xB0\x9F\x01")
      end

      it_behaves_like "a fluid interface"
    end
  end
end
