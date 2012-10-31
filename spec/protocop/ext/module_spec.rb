require "spec_helper"

describe Module do

  describe "#__protofield__" do

    before(:all) do
      class Request
        include Protocop::Message
        module Type
          QUERY = 0
          COUNT = 1
        end
      end
    end

    after(:all) do
      Object.__send__(:remove_const, :Request)
    end

    let(:field) do
      Request::Type.__protofield__(Request::Type, :test, 1)
    end

    it "sets the type" do
      expect(field.type).to eq(Request::Type)
    end

    it "sets the name" do
      expect(field.name).to eq(:test)
    end

    it "sets the number" do
      expect(field.number).to eq(1)
    end
  end
end
