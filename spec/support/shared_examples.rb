shared_examples_for "a fluid interface" do

  it "returns the buffer" do
    expect(written).to eq(buffer)
  end
end

shared_examples_for "a serializer" do |reader, writer, value|

  describe "##{reader}/##{writer}" do

    let(:written) do
      buffer.send(writer, value)
    end

    let(:read) do
      written.send(reader)
    end

    it "serializes and deserializes the value" do
      expect(read).to eq(value)
    end

    it_behaves_like "a fluid interface"
  end
end
