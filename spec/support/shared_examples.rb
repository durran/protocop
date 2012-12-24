shared_examples_for "a fluid interface" do

  it "returns the buffer" do
    expect(written).to eq(buffer)
  end
end
