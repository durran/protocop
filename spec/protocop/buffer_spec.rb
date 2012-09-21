require "spec_helper"

describe Protocop::Buffer do

  describe "#initialize" do

    let(:buffer) do
      described_class.new
    end

    it "sets the bytes to an empty string" do
      expect(buffer.bytes).to eq("")
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

      it "returns the buffer" do
        expect(written).to equal(buffer)
      end
    end

    context "when the string is nil" do

      let(:written) do
        buffer.write_string(nil)
      end

      it "does not add anything to the buffer" do
        expect(written.bytes).to eq("")
      end

      it "returns the buffer" do
        expect(written).to equal(buffer)
      end
    end

    context "when the string is not empty" do

      let(:written) do
        buffer.write_string("test")
      end

      it "adds the string to the buffer" do
        expect(written.bytes).to eq("test")
      end

      it "returns the buffer" do
        expect(written).to equal(buffer)
      end
    end
  end

  pending "#write_varint" do

  end
end
