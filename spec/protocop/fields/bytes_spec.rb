require "spec_helper"

describe Protocop::Fields::Bytes do

  let(:buffer) do
    Protocop::Buffer.new
  end

  describe "#encode" do

    context "when the field is not repeated" do

      let(:field) do
        described_class.new(:bytes, :test, 1)
      end

      context "when the bytes are empty" do

        let!(:written) do
          field.encode(buffer, "")
        end

        it "encodes the field, type and length plus the bytes" do
          expect(buffer.bytes).to eq("\n\x00")
        end

        it_behaves_like "a fluid interface"
      end

      context "when the bytes are not empty" do

        let!(:written) do
          field.encode(buffer, "\x01\x02")
        end

        it "encodes the field, type and length plus the bytes" do
          expect(buffer.bytes).to eq("\n\x02\x01\x02")
        end

        it_behaves_like "a fluid interface"
      end
    end

    context "when the field is repeated" do

      context "when the field is not packed" do

        let(:field) do
          described_class.new(:bytes, :test, 1, repeated: true)
        end

        context "when the bytes are empty" do

          let!(:written) do
            field.encode(buffer, [ "" ])
          end

          it "encodes the field, type and length plus the bytes" do
            expect(buffer.bytes).to eq("\n\x00")
          end

          it_behaves_like "a fluid interface"
        end

        context "when the bytes are not empty" do

          let!(:written) do
            field.encode(buffer, [ "\x01\x02", "\x03" ])
          end

          it "encodes the field, type and length plus the bytes" do
            expect(buffer.bytes).to eq("\n\x02\x01\x02\n\x01\x03")
          end

          it_behaves_like "a fluid interface"
        end
      end

      context "when the field is packed" do

        let(:field) do
          described_class.new(:bytes, :test, 1, repeated: true, packed: true)
        end

        context "when the bytes are empty" do

          let!(:written) do
            field.encode(buffer, [])
          end

          it "encodes the field, type and length plus the bytes" do
            expect(buffer.bytes).to eq("")
          end

          it_behaves_like "a fluid interface"
        end

        context "when the bytes are not empty" do

          let!(:written) do
            field.encode(buffer, [ "\x01\x02", "\x03" ])
          end

          it "encodes the field, type and length plus the bytes" do
            expect(buffer.bytes).to eq("\n\x03\x01\x02\x03")
          end

          it_behaves_like "a fluid interface"
        end
      end
    end
  end
end
