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

  it "has categories" do
    expect(subject.categories).to eq([])
  end

  context "method chaining venues" do
    let(:food_category) { '4d4b7105d754a06374d81259' }

    describe "#with_category" do
      before do
      	@venues = subject.with_category(food_category)
      end

      it "set with #options['categoryId'] to food_category" do
        expect(@venues.options['categoryId']).to eq(food_category)
      end

      it "#categories include food_category" do
        expect(@venues.categories.include? food_category).to eq(true)
      end
    end

    after do
      expect(@venues.kind_of? Foursquare::Venues).to eq(true)
    end
  end
end