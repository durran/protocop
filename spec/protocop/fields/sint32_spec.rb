require "spec_helper"

describe Protocop::Fields::Sint32 do

  let(:field) do
    described_class.new(:sint32, :test, 1)
  end

  let(:buffer) do
    Protocop::Buffer.new
  end

  describe "#encode" do

    let!(:written) do
      field.encode(buffer, 150)
    end

    it "encodes the field, type and integer" do
      expect(buffer.bytes).to eq("\x08\xAC\x02")
    end

    it_behaves_like "a fluid interface"
  end
end
