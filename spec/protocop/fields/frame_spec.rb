require "spec_helper"

describe Protocop::Fields::Frame do

  describe "#default" do

    let(:klass) do
      Class.new do
        include Protocop::Fields::Frame
      end
    end

    context "when the option is nil" do

      let(:field) do
        klass.new(:string, :test, 1)
      end

      it "returns nil" do
        expect(field.default).to be_nil
      end
    end

    context "when the option is provided" do

      let(:field) do
        klass.new(:string, :test, 1, default: "test")
      end

      it "returns false" do
        expect(field.default).to eq("test")
      end
    end
  end

  describe "#required?" do

    let(:klass) do
      Class.new do
        include Protocop::Fields::Frame
      end
    end

    context "when the option is nil" do

      let(:field) do
        klass.new(:string, :test, 1)
      end

      it "returns false" do
        expect(field).to_not be_required
      end
    end

    context "when the option is false" do

      let(:field) do
        klass.new(:string, :test, 1, required: false)
      end

      it "returns false" do
        expect(field).to_not be_required
      end
    end

    context "when the option is true" do

      let(:field) do
        klass.new(:string, :test, 1, required: true)
      end

      it "returns true" do
        expect(field).to be_required
      end
    end
  end
end
