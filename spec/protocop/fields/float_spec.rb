require "spec_helper"

describe Protocop::Fields::Float do

  let(:field) do
    described_class.new(1)
  end

  let(:buffer) do
    Protocop::Buffer.new
  end

  describe "#encode" do

    let!(:written) do
      field.encode(buffer, 10.345)
    end

    it "encodes the field, type and float" do
      expect(buffer.bytes).to eq("\r\x1F\x85%A")
    end

    it_behaves_like "a fluid interface"
  end
end
