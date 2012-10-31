require "spec_helper"

describe Protocop::Fields::Double do

  let(:field) do
    described_class.new(:double, :test, 1)
  end

  let(:buffer) do
    Protocop::Buffer.new
  end

  describe "#encode" do

    let!(:written) do
      field.encode(buffer, 10.345)
    end

    it "encodes the field, type and double" do
      expect(buffer.bytes).to eq("\tq=\n\xD7\xA3\xB0$@")
    end

    it_behaves_like "a fluid interface"
  end
end
