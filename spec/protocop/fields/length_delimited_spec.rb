require "spec_helper"

describe Protocop::Fields::LengthDelimited do

  describe "#key" do

    let(:klass) do
      Class.new do
        include Protocop::Fields::LengthDelimited
      end
    end

    let(:field) do
      klass.new(:length_delimited, :test, 1)
    end

    it "returns the integer for the number and the wire type" do
      expect(field.key).to eq(10)
    end
  end

  describe "#packable?" do

    let(:klass) do
      Class.new do
        include Protocop::Fields::LengthDelimited
      end
    end

    let(:field) do
      klass.new(:string, :test, 1)
    end

    it "returns false" do
      expect(field).to_not be_packable
    end
  end
end
