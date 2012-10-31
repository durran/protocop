require "spec_helper"

describe Symbol do

  describe "#__protofield__" do

    let(:field) do
      :int32.__protofield__(:int32, :test, 1)
    end

    it "sets the type" do
      expect(field.type).to eq(:int32)
    end

    it "sets the name" do
      expect(field.name).to eq(:test)
    end

    it "sets the number" do
      expect(field.number).to eq(1)
    end
  end

  describe "#__setter__" do

    let(:setter) do
      :testing.__setter__
    end

    it "returns the symbol plus = as a string" do
      expect(setter).to eq("testing=")
    end
  end
end
