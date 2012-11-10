require "spec_helper"

describe Protocop::Fields::Double do

  let(:buffer) do
    Protocop::Buffer.new
  end

  describe "#encode" do

    context "when the field is not repeated" do

      let(:field) do
        described_class.new(:double, :test, 1)
      end

      let!(:written) do
        field.encode(buffer, 10.345)
      end

      it "encodes the field, type and double" do
        expect(buffer.bytes).to eq("\tq=\n\xD7\xA3\xB0$@")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the field is repeated" do

      context "when the field is not packed" do

        let(:field) do
          described_class.new(:double, :test, 1, repeated: true)
        end

        let!(:written) do
          field.encode(buffer, [ 10.345, 1.1 ])
        end

        it "encodes the field, type and double" do
          expect(buffer.bytes).to eq(
            "\tq=\n\xD7\xA3\xB0$@\t\x9A\x99\x99\x99\x99\x99\xF1?"
          )
        end

        it_behaves_like "a fluid interface"
      end

      context "when the field is packed" do

        let(:field) do
          described_class.new(:double, :test, 1, repeated: true, packed: true)
        end

        let!(:written) do
          field.encode(buffer, [ 10.345, 1.1 ])
        end

        it "encodes the field, type and double" do
          expect(buffer.bytes).to eq(
            "\n\x10q=\n\xD7\xA3\xB0$@\x9A\x99\x99\x99\x99\x99\xF1?"
          )
        end

        it_behaves_like "a fluid interface"
      end
    end
  end
end
