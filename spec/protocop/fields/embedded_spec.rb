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

  let(:field) do
    described_class.new(Request, :test, 1)
  end

  let(:buffer) do
    Protocop::Buffer.new
  end

  describe "#encode" do

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
end
