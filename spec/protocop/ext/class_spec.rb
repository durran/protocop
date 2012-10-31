require "spec_helper"

describe Module do

  describe "#__protofield__" do

    before(:all) do
      class Request
        include Protocop::Message
      end
    end

    after(:all) do
      Object.__send__(:remove_const, :Request)
    end

    let(:field) do
      Request.__protofield__(Request, :test, 1)
    end

    it "sets the type" do
      expect(field.type).to eq(Request)
    end

    it "sets the name" do
      expect(field.name).to eq(:test)
    end

    it "sets the number" do
      expect(field.number).to eq(1)
    end
  end
end
