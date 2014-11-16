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
    let(:latlng) { '14.6371574,121.073077' }

    describe "#with_category" do
      before do
      	@venues = subject.with_category(food_category)
      end

      it "sets #options['categoryId'] to food_category" do
        expect(@venues.options['categoryId']).to eq(food_category)
      end

      it "#categories include food_category" do
        expect(@venues.categories.include? food_category).to eq(true)
      end
    end

    describe "#near" do
      it "sets #options[:ll] to latlng" do
        @venues = subject.near(latlng)
        expect(@venues.options[:ll]).to eq(latlng)
      end

      it "sets #options[:llAcc] to 10 meters" do
        @venues = subject.near(latlng, 10)
        expect(@venues.options[:llAcc]).to eq(10)
      end
    end

    describe "#above" do
      it "sets #options[:alt] to 100 meters" do
        @venues = subject.above(100)
        expect(@venues.options[:alt]).to eq(100)
      end

      it "sets #options[:altAcc] to 1 meters" do
        @venues = subject.above(100, 1)
        expect(@venues.options[:altAcc]).to eq(1)
      end
    end

    describe "#within" do
      it "sets #options[:radius] to 80 meters" do
        @venues = subject.within(80)
        expect(@venues.options[:radius]).to eq(80)
      end
    end

    describe "#top" do
      it "sets #options[:limit] to 20" do
        @venues = subject.top(20)
        expect(@venues.options[:limit]).to eq(20)
      end
    end

    describe "#search" do
      it "sets #options[:query] to coffee" do
        @venues = subject.search('coffee')
        expect(@venues.options[:query]).to eq('coffee')
      end
    end

    describe "#for" do
      it "sets #options[:intent] to checkin" do
        @venues = subject.for('checkin')
        expect(@venues.options[:intent]).to eq('checkin')
      end
    end

    after do
      expect(@venues.kind_of? Foursquare::Venues).to eq(true)
    end
  end
end