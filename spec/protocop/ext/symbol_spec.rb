require "spec_helper"

describe Symbol do

  describe "#__setter__" do

    let(:setter) do
      :testing.__setter__
    end

    it "returns the symbol plus = as a string" do
      expect(setter).to eq("testing=")
    end
  end
end
