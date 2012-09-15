require "spec_helper"

describe String do

  describe "#__setter__" do

    let(:setter) do
      "testing".__setter__
    end

    it "returns the string plus =" do
      expect(setter).to eq("testing=")
    end
  end
end
