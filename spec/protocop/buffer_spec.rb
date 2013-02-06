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

  it_behaves_like "a serializer", :read_boolean,  :write_boolean, true
  it_behaves_like "a serializer", :read_boolean,  :write_boolean, false
  it_behaves_like "a serializer", :read_bytes,    :write_bytes,   "test"

  it_behaves_like "a serializer", :read_string,   :write_string,  "test"

  describe "#write_string" do

    context "when the string is empty" do

      let(:written) do
        buffer.write_string("")
      end

      it "does not add anything to the buffer" do
        expect(buffer.bytes).to eq("")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the string is nil" do

      let(:written) do
        buffer.write_string(nil)
      end

      it "does not add anything to the buffer" do
        expect(buffer.bytes).to eq("")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the string is not empty" do

      let(:written) do
        buffer.write_string("test")
      end

      it "adds the string to the buffer" do
        expect(written.read_string).to eq("test")
      end

      it_behaves_like "a fluid interface"
    end
  end

  it_behaves_like "a serializer", :read_double,   :write_double,  1.23131

  # it_behaves_like "a serializer", :read_float,    :write_float,   1.23

  it_behaves_like "a serializer", :read_fixed32,  :write_fixed32, 152

  describe "#write_fixed32" do

    context "when the value is greater than 32 bit" do

      it "raises an error" do
        expect {
          buffer.write_fixed32(2 ** 34)
        }.to raise_error(Protocop::Buffer::OutsideRange)
      end
    end
  end

  it_behaves_like "a serializer", :read_fixed64,  :write_fixed64, 142576

  describe "#write_fixed64" do

    context "when the value is greater than 64 bit" do

      it "raises an error" do
        expect {
          buffer.write_fixed64(2 ** 65)
        }.to raise_error(Protocop::Buffer::OutsideRange)
      end
    end
  end

  it_behaves_like "a serializer", :read_int32,    :write_int32,   1
  it_behaves_like "a serializer", :read_int32,    :write_int32,   Integer::MAX_SIGNED_32BIT
  it_behaves_like "a serializer", :read_int32,    :write_int32,   -1
  it_behaves_like "a serializer", :read_int32,    :write_int32,   Integer::MIN_SIGNED_32BIT

  describe "#write_int32" do

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

  it_behaves_like "a serializer", :read_int64,    :write_int64,   1
  it_behaves_like "a serializer", :read_int64,    :write_int64,   Integer::MAX_SIGNED_64BIT
  it_behaves_like "a serializer", :read_int64,    :write_int64,   -1
  it_behaves_like "a serializer", :read_int64,    :write_int64,   Integer::MIN_SIGNED_64BIT

  describe "#write_int64" do

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

  it_behaves_like "a serializer", :read_sfixed32, :write_sfixed32, 1000

  describe "#write_sfixed32" do

    context "when the value is greater than 32 bit" do

      it "raises an error" do
        expect {
          buffer.write_sfixed32(2 ** 34)
        }.to raise_error(Protocop::Buffer::OutsideRange)
      end
    end
  end

  it_behaves_like "a serializer", :read_sfixed64, :write_sfixed64, 142576

  describe "#write_sfixed64" do

    context "when the value is greater than 64 bit" do

      it "raises an error" do
        expect {
          buffer.write_sfixed64(2 ** 65)
        }.to raise_error(Protocop::Buffer::OutsideRange)
      end
    end
  end

  it_behaves_like "a serializer", :read_sint32,   :write_sint32,   1000

  describe "#write_sint32" do

    context "when the value is greater than 32 bit" do

      it "raises an error" do
        expect {
          buffer.write_sint32(2 ** 34)
        }.to raise_error(Protocop::Buffer::OutsideRange)
      end
    end
  end

  it_behaves_like "a serializer", :read_sint64,   :write_sint64,   142576

  describe "#write_sint64" do

    context "when the value is greater than 64 bit" do

      it "raises an error" do
        expect {
          buffer.write_sint64(2 ** 65)
        }.to raise_error(Protocop::Buffer::OutsideRange)
      end
    end
  end

  it_behaves_like "a serializer", :read_uint32,   :write_uint32,   1000

  describe "#write_uint32" do

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

  it_behaves_like "a serializer", :read_uint64,   :write_uint64,   142576

  describe "#write_uint64" do


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

  it_behaves_like "a serializer", :read_varint,   :write_varint,   5
  it_behaves_like "a serializer", :read_varint,   :write_varint,   130
  it_behaves_like "a serializer", :read_varint,   :write_varint,   20400
  it_behaves_like "a serializer", :read_varint,   :write_varint,   10001231231
end
