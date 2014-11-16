require 'foursquare/venues'

describe Foursquare::Venues do
  subject { Foursquare::Venues.new(mock_client) }

  let(:mock_client) { double("Object", search_venues: search_response) }
  let(:search_response) { double("Object", venues: fetched_venues) }
  let(:fetched_venues) { [{id: 1, name: 'Jollibee'}, {id: 2, name: 'Chowking'}, {id: 3, name: 'Mang inasal'}] }
  let(:food_category) { '4d4b7105d754a06374d81259' }
  let(:latlng) { '14.6371574,121.073077' }

  it "has a client" do
    expect(subject.client.nil?).to eq(false)
  end

  it "has options" do
    expect(subject.options).to eq({})
  end

  it "has categories" do
    expect(subject.categories).to eq([])
  end

  context "method chaining" do
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

      it "sets #options['llAcc'] to 10 meters" do
        @venues = subject.near(latlng, 10)
        expect(@venues.options['llAcc']).to eq(10)
      end
    end

    describe "#above" do
      it "sets #options[:alt] to 100 meters" do
        @venues = subject.above(100)
        expect(@venues.options[:alt]).to eq(100)
      end

      it "sets #options['altAcc'] to 1 meters" do
        @venues = subject.above(100, 1)
        expect(@venues.options['altAcc']).to eq(1)
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

    it "retains options" do
      @venues = subject.with_category(food_category).near(latlng).above(100).top(20).search('coffee').for('specials')
      expect(@venues.options).to eq({'categoryId' => food_category, :ll => latlng, :alt => 100, :limit => 20, :query => 'coffee', :intent => 'specials'})
    end

    after do
      expect(@venues.kind_of? Foursquare::Venues).to eq(true)
    end
  end

  context "enumerate venues" do
    before do
      @venues = subject.with_category(food_category).near(latlng, 10).above(100, 1).top(20).search('restaurant').for('match')
    end

    it "calls client#search_venues" do
      expect(mock_client).to receive(:search_venues) do |options|
        expect(options['categoryId']).to eq(food_category)
        expect(options[:ll]).to eq(latlng)
        expect(options['llAcc']).to eq(10)
        expect(options[:alt]).to eq(100)
        expect(options['altAcc']).to eq(1)
        expect(options[:limit]).to eq(20)
        expect(options[:query]).to eq('restaurant')
        expect(options[:intent]).to eq('match')
      end
      
      expect(@venues.to_a).to eq([])
    end

    it "fetches venues" do
      expect(@venues.to_a).to eq(fetched_venues)
    end

    it 'random selects venue' do
      venue = @venues.sample
      expect(venue.nil?).to eq(false)
      expect(fetched_venues.include? venue).to eq(true)
    end
  end

  context "Sub Class" do
    subject(:sub_type) { FoodVenues.new(:mock_client) }

    class FoodVenues < Foursquare::Venues
    end

    it "chain the same class" do
      expect(sub_type.search('vegetarian').class).to eq(FoodVenues)
    end
  end
end