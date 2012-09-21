require "spec_helper"

describe Protocop::Buffer do

  describe "#initialize" do

    context "when no bytes are provided" do

      let(:buffer) do
        described_class.new
      end

      it "sets the bytes to an empty string" do
        expect(buffer.bytes).to eq("")
      end
    end

    context "when bytes are provided" do

      let(:buffer) do
        described_class.new("test")
      end

      it "sets the bytes" do
        expect(buffer.bytes).to eq("test")
      end
    end
  end
end
