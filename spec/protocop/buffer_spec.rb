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

      it "does not add anything to the buffer" do
        expect(buffer.write_string("")).to eq("")
      end

      it "returns the buffer" do
        expect(buffer.write_string("")).to equal(buffer)
      end
    end

    context "when the string is nil" do

      it "does not add anything to the buffer" do
        expect(buffer.write_string(nil)).to eq("")
      end

      it "returns the buffer" do
        expect(buffer.write_string(nil)).to equal(buffer)
      end
    end

    context "when the string is not empty" do

      it "adds the string to the buffer" do
        expect(buffer.write_string("test")).to eq("test")
      end

      it "returns the buffer" do
        expect(buffer.write_string("test")).to equal(buffer)
      end
    end
  end

  describe "#write_varint" do

  end
end
