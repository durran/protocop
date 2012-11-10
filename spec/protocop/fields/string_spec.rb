require "spec_helper"

describe Protocop::Fields::String do

  let(:buffer) do
    Protocop::Buffer.new
  end

  describe "#encode" do

    context "when the value is not repeated" do

      let(:field) do
        described_class.new(:string, :test, 1)
      end

      context "when the string is empty" do

        let!(:written) do
          field.encode(buffer, "")
        end

        it "encodes the field, type and length plus the string" do
          expect(buffer.bytes).to eq("\n\x00")
        end

        it_behaves_like "a fluid interface"
      end

      context "when the string is not empty" do

        let!(:written) do
          field.encode(buffer, "testing")
        end

        it "encodes the field, type and length plus the string" do
          expect(buffer.bytes).to eq("\n\x07testing")
        end

        it_behaves_like "a fluid interface"
      end
    end

    context "when the value is repeated" do

      context "when the field is not packed" do

        let(:field) do
          described_class.new(:string, :test, 1, repeated: true)
        end

        context "when the string is empty" do

          let!(:written) do
            field.encode(buffer, [""])
          end

          it "encodes the field, type and length plus the string" do
            expect(buffer.bytes).to eq("\n\x00")
          end

          it_behaves_like "a fluid interface"
        end

        context "when the string is not empty" do

          let!(:written) do
            field.encode(buffer, [ "test", "testing" ])
          end

          it "encodes the field, type and length plus the string" do
            expect(buffer.bytes).to eq("\n\x04test\n\x07testing")
          end

          it_behaves_like "a fluid interface"
        end
      end

      pending "when the field is packed" do

        let(:field) do
          described_class.new(:string, :test, 1, repeated: true, packed: true)
        end

        let!(:written) do
          field.encode(buffer, [ "test", "testing" ])
        end

        it "encodes the field, type and length plus the string" do
          expect(buffer.bytes).to eq("\n\vtesttesting")
        end

        it_behaves_like "a fluid interface"
      end
    end
  end
end
