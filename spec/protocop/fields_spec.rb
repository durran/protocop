require "spec_helper"

describe Protocop::Fields do

  describe ".required" do

    context "when defining a string field" do

      before(:all) do
        class Request
          include Protocop::Message
          required :string, :name, 1
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :Request)
      end

      let(:field) do
        Request.fields[:name]
      end

      it "adds the field to the class" do
        expect(field).to be_a(Protocop::Fields::String)
      end

      it "sets the field number" do
        expect(field.number).to eq(1)
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

        it "provides access to the fields from the instance" do
          expect(message.fields).to eq(Request.fields)
        end
      end
    end
  end
end
