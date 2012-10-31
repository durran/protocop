require "spec_helper"

describe Protocop::Fields do

  describe "#fields" do

    before(:all) do
      class Request
        include Protocop::Message
        required :string, :name, 1
      end
    end

    after(:all) do
      Object.__send__(:remove_const, :Request)
    end

    let(:message) do
      Request.new
    end

    it "returns the fields from the class" do
      message.fields.should eq(Request.fields)
    end
  end
end
