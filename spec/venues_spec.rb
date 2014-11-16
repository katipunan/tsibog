require 'foursquare/venues'

describe Foursquare::Venues do
  subject { Foursquare::Venues.new(mock_client) }

  let(:mock_client) { Object.new }

  it "has a client" do
  	expect(subject.client.nil?).to eq(false)
  end

  it "has options" do
  	expect(subject.options).to eq({})
  end
  it "has categories"
end