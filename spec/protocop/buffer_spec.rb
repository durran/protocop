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

  describe "#read_boolean" do

    context "when the byte is 1" do

      before do
        buffer.write_boolean(true)
      end

      let(:read) do
        buffer.read_boolean
      end

      it "returns true" do
        expect(read).to eq(true)
      end
    end

    context "when the byte is 0" do

      before do
        buffer.write_boolean(false)
      end

      let(:read) do
        buffer.read_boolean
      end

      it "returns false" do
        expect(read).to eq(false)
      end
    end
  end

  describe "#read_double" do

    before do
      buffer.write_double(1.23131)
    end

    let(:read) do
      buffer.read_double
    end

    it "returns the double" do
      expect(read).to eq(1.23131)
    end
  end

  describe "#read_fixed32" do

    before do
      buffer.write_fixed32(152)
    end

    let(:read) do
      buffer.read_fixed32
    end

    it "returns the double" do
      expect(read).to eq(152)
    end
  end

  describe "#read_fixed64" do

    before do
      buffer.write_fixed64(142576)
    end

    let(:read) do
      buffer.read_fixed64
    end

    it "returns the double" do
      expect(read).to eq(142576)
    end
  end

  describe "#write_boolean" do

    context "when the boolean is true" do

      let(:written) do
        buffer.write_boolean(true)
      end

      it "adds the boolean to the buffer" do
        expect(written.read_boolean).to eq(true)
      end

      it_behaves_like "a fluid interface"
    end

    context "when the boolean is false" do

      let(:written) do
        buffer.write_boolean(false)
      end

      it "adds the boolean to the buffer" do
        expect(written.read_boolean).to eq(false)
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

    it "adds the double to the buffer" do
      expect(written.read_double).to eq(1.21)
    end

    it_behaves_like "a fluid interface"
  end

  describe "#write_fixed32" do

    let(:written) do
      buffer.write_fixed32(1)
    end

    it "adds the int to the buffer" do
      expect(written.read_fixed32).to eq(1)
    end

    it_behaves_like "a fluid interface"

    context "when the value is greater than 32 bit" do

      it "raises an error" do
        expect {
          buffer.write_fixed32(2 ** 34)
        }.to raise_error(Protocop::Buffer::OutsideRange)
      end
    end
  end

  describe "#write_fixed64" do

    let(:written) do
      buffer.write_fixed64(1)
    end

    it "adds the int to the buffer" do
      expect(written.read_fixed64).to eq(1)
    end

    it_behaves_like "a fluid interface"

    context "when the value is greater than 64 bit" do

      it "raises an error" do
        expect {
          buffer.write_fixed64(2 ** 65)
        }.to raise_error(Protocop::Buffer::OutsideRange)
      end
    end
  end

  describe "#write_float" do

    let(:written) do
      buffer.write_float(1.2)
    end

    it "constrains the float to 4 bytes" do
      expect(written.bytes.length).to eq(4)
    end

    pending "adds the float to the buffer" do
      expect(written.read_float).to eq(1.2)
    end

    it_behaves_like "a fluid interface"
  end

  describe "#write_int32" do

    context "when the value is 32 bit" do

      context "when the integer is positive" do

        context "when appending a small integer" do

          let(:written) do
            buffer.write_int32(1)
          end

          it "adds the int to the buffer" do
            expect(written.bytes).to eq("\x01")
          end

          it_behaves_like "a fluid interface"
        end

        context "when appending the largest 32bit integer" do

          let(:written) do
            buffer.write_int32(Integer::MAX_SIGNED_32BIT)
          end

          it "adds the int to the buffer" do
            expect(written.bytes).to eq("\xFF\xFF\xFF\xFF\a")
          end

          it_behaves_like "a fluid interface"
        end
      end

      context "when the integer is negative" do

        context "when appending a small negative integer" do

          let(:written) do
            buffer.write_int32(-1)
          end

          it "adds the int to the buffer" do
            expect(written.bytes).to eq("\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x01")
          end

          it_behaves_like "a fluid interface"
        end

        context "when appending the smallest 32bit integer" do

          let(:written) do
            buffer.write_int32(Integer::MIN_SIGNED_32BIT)
          end

          it "adds the int to the buffer" do
            expect(written.bytes).to eq("\x80\x80\x80\x80\xF8\xFF\xFF\xFF\xFF\x01")
          end

          it_behaves_like "a fluid interface"
        end
      end
    end

    context "when the value is too high" do

      it "raises an error" do
        expect {
          buffer.write_int32(Integer::MAX_SIGNED_32BIT + 1)
        }.to raise_error(Protocop::Buffer::OutsideRange)
      end
    end

    context "when the value is too low" do

      it "raises an error" do
        expect {
          buffer.write_int32(Integer::MIN_SIGNED_32BIT - 1)
        }.to raise_error(Protocop::Buffer::OutsideRange)
      end
    end
  end

  describe "#write_int64" do

    context "when the value is 64 bit" do

      context "when the integer is positive" do

        context "when appending a small integer" do

          let(:written) do
            buffer.write_int64(1)
          end

          it "adds the int to the buffer" do
            expect(written.bytes).to eq("\x01")
          end

          it_behaves_like "a fluid interface"
        end

        context "when appending the largest 64bit integer" do

          let(:written) do
            buffer.write_int64(Integer::MAX_SIGNED_64BIT)
          end

          it "adds the int to the buffer" do
            expect(written.bytes).to eq("\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F")
          end

          it_behaves_like "a fluid interface"
        end
      end

      context "when the integer is negative" do

        context "when appending a small negative integer" do

          let(:written) do
            buffer.write_int64(-1)
          end

          it "adds the int to the buffer" do
            expect(written.bytes).to eq("\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x01")
          end

          it_behaves_like "a fluid interface"
        end

        context "when appending the smallest 64bit integer" do

          let(:written) do
            buffer.write_int64(Integer::MIN_SIGNED_64BIT)
          end

          it "adds the int to the buffer" do
            expect(written.bytes).to eq("\x80\x80\x80\x80\x80\x80\x80\x80\x80\x01")
          end

          it_behaves_like "a fluid interface"
        end
      end
    end

    context "when the value is too high" do

      it "raises an error" do
        expect {
          buffer.write_int64(Integer::MAX_SIGNED_64BIT + 1)
        }.to raise_error(Protocop::Buffer::OutsideRange)
      end
    end

    context "when the value is too low" do

      it "raises an error" do
        expect {
          buffer.write_int64(Integer::MIN_SIGNED_64BIT - 1)
        }.to raise_error(Protocop::Buffer::OutsideRange)
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
        }.to raise_error(Protocop::Buffer::OutsideRange)
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
        }.to raise_error(Protocop::Buffer::OutsideRange)
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
        }.to raise_error(Protocop::Buffer::OutsideRange)
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
        }.to raise_error(Protocop::Buffer::OutsideRange)
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
        }.to raise_error(Protocop::Buffer::OutsideRange)
      end
    end

    context "when the value is greater than 32bit" do

      it "raises an error" do
        expect {
          buffer.write_uint32(2 ** 40)
        }.to raise_error(Protocop::Buffer::OutsideRange)
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
        }.to raise_error(Protocop::Buffer::OutsideRange)
      end
    end

    context "when the value is greater than 64bit" do

      it "raises an error" do
        expect {
          buffer.write_uint64(2 ** 70)
        }.to raise_error(Protocop::Buffer::OutsideRange)
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
