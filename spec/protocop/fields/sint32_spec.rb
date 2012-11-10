require "spec_helper"

describe Protocop::Fields::Sint32 do

  let(:buffer) do
    Protocop::Buffer.new
  end

  describe "#encode" do

    context "when the field is not repeated" do

      let(:field) do
        described_class.new(:sint32, :test, 1)
      end

      let!(:written) do
        field.encode(buffer, 150)
      end

      it "encodes the field, type and integer" do
        expect(buffer.bytes).to eq("\x08\xAC\x02")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the field is repeated" do

      context "when the field is not packed" do

        let(:field) do
          described_class.new(:sint32, :test, 1, repeated: true)
        end

        let!(:written) do
          field.encode(buffer, [ 150, 1 ])
        end

        it "encodes the field, type and integer" do
          expect(buffer.bytes).to eq("\x08\xAC\x02\x08\x02")
        end

        it_behaves_like "a fluid interface"
      end

      context "when the field is packed" do

        let(:field) do
          described_class.new(:sint32, :test, 1, repeated: true, packed: true)
        end

        let!(:written) do
          field.encode(buffer, [ 150, 1 ])
        end

        it "encodes the field, type and integer" do
          expect(buffer.bytes).to eq("\n\x03\xAC\x02\x02")
        end

        it_behaves_like "a fluid interface"
      end
    end
  end
end
