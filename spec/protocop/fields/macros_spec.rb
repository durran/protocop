require "spec_helper"

describe Protocop::Fields::Macros do

  describe ".required" do

    context "when providing an embedded message" do

      before(:all) do
        class Command
          include Protocop::Message
          required :string, :name, 1
        end
        class Request
          include Protocop::Message
          required Command, :command, 2
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :Command)
        Object.__send__(:remove_const, :Request)
      end

      let(:field) do
        Request.fields[:command]
      end

      it "adds the field to the class" do
        expect(field).to be_a(Protocop::Fields::Embedded)
      end

      it "sets the field number" do
        expect(field.number).to eq(2)
      end

      it "sets the field type" do
        expect(field.type).to eq(Command)
      end

      it "sets the field to required" do
        expect(field).to be_required
      end
    end

    context "when defining an enum" do

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

      context "when providing a default" do

        before do
          Request.required(Request::Type, :type, 1, default: Request::Type::COUNT)
        end

        let(:field) do
          Request.fields[:type]
        end

        it "adds the field to the class" do
          expect(field).to be_a(Protocop::Fields::Enum)
        end

        it "sets the field number" do
          expect(field.number).to eq(1)
        end

        it "sets the field type" do
          expect(field.type).to eq(Request::Type)
        end

        it "sets the default options" do
          expect(field.default).to eq(Request::Type::COUNT)
        end
      end

      context "when not providing a default" do

        before do
          Request.required(Request::Type, :type, 1)
        end

        let(:field) do
          Request.fields[:type]
        end

        it "adds the field to the class" do
          expect(field).to be_a(Protocop::Fields::Enum)
        end

        it "sets the field number" do
          expect(field.number).to eq(1)
        end

        it "sets the field type" do
          expect(field.type).to eq(Request::Type)
        end

        it "does not set a default option" do
          expect(field.default).to be_nil
        end
      end
    end

    context "when defining a field with a default" do

      before(:all) do
        class Request
          include Protocop::Message
          required :string, :name, 1, default: "testing"
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :Request)
      end

      context "when getting the field value" do

        let(:message) do
          Request.new
        end

        it "returns the default" do
          expect(message.name).to eq("testing")
        end
      end
    end

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
