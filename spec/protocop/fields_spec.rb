require "spec_helper"

describe Protocop::Fields do

  describe ".required" do

    context "when defining a string field" do

      before(:all) do
        class Request
          extend Protocop::Fields::Definitions
          required :string, :name, 1
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :Request)
      end

      it "adds the field to the class" do
        Request.fields[:name].should be_a(Protocop::Fields::String)
      end

      context "when setting the string via the setter" do

        let(:message) do
          Request.new
        end

        let!(:string) do
          message.name = "testing"
        end

        it "sets the string in the message" do
          expect(message.name).to eq("testing")
        end

        it "returns the set string" do
          expect(string).to eq("testing")
        end
      end
    end
  end
end
