require "spec_helper"

describe Protocop::Fields::Embedded do

  before(:all) do
    class Request
      include Protocop::Message
      required :string, :test, 1
    end
  end

  after(:all) do
    Object.__send__(:remove_const, :Request)
  end

  let(:buffer) do
    Protocop::Buffer.new
  end

  describe "#encode" do

    context "when the field is not repeated" do

      let(:field) do
        described_class.new(Request, :test, 1)
      end

      let(:request) do
        Request.new(test: "testing")
      end

      let!(:written) do
        field.encode(buffer, request)
      end

      it "encodes the field, type and integer" do
        expect(buffer.bytes).to eq("\n\n\x07testing")
      end

      it_behaves_like "a fluid interface"
    end

    context "when the field is repeated" do

      context "when the field is not packed" do

        let(:field) do
          described_class.new(Request, :test, 1, repeated: true)
        end

        let(:request_one) do
          Request.new(test: "testing")
        end

        let(:request_two) do
          Request.new(test: "test")
        end

        let!(:written) do
          field.encode(buffer, [ request_one, request_two ])
        end

        it "encodes the field, type and integer" do
          expect(buffer.bytes).to eq("\n\n\atesting\n\n\x04test")
        end

        it_behaves_like "a fluid interface"
      end
    end
  end
end
