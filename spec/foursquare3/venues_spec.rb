require 'foursquare3/venues'

describe Foursquare3::Venues do
  subject { Foursquare3::Venues.new(request) }

  let(:request) { Hash.new('venues' => fetched_venues) }
  let(:fetched_venues) { [{id: 1, name: 'Jollibee'}, {id: 2, name: 'Chowking'}, {id: 3, name: 'Mang inasal'}] }
  let(:food_category) { '4d4b7105d754a06374d81259' }
  let(:latlng) { '14.6371574,121.073077' }

  it "has options" do
    expect(subject.options).to eq({})
  end

  it "has categories" do
    expect(subject.categories).to eq([])
  end

  context "options setters" do
    describe "#with_category" do
      before do
        @venues = subject.with_category(food_category)
      end

      it "sets #categories to include category" do
        expect(@venues.categories).to include(food_category)
      end

      it "sets category id" do
        expect(@venues.options).to eq('categoryId' => food_category)
      end
    end

    describe "#near" do
      it "sets geolocation" do
        @venues = subject.near(latlng)
        expect(@venues.options).to eq(ll: latlng)
      end

      it "sets geolocation with accuracy" do
        @venues = subject.near(latlng, 10)
        expect(@venues.options).to eq(:ll => latlng, 'llAcc' => 10)
      end
    end

    describe "#above" do
      it "sets altitude" do
        @venues = subject.above(100)
        expect(@venues.options).to eq(alt: 100)
      end

      it "sets altitude with accuracy" do
        @venues = subject.above(100, 1)
        expect(@venues.options).to eq(alt: 100, 'altAcc' => 1)
      end
    end

    describe "#within" do
      it "sets radius" do
        @venues = subject.within(80)
        expect(@venues.options).to eq(radius: 80)
      end
    end

    describe "#top" do
      it "sets limit" do
        @venues = subject.top(20)
        expect(@venues.options).to eq(limit: 20)
      end
    end

    describe "#search" do
      it "sets query" do
        @venues = subject.search('coffee')
        expect(@venues.options).to eq(query: 'coffee')
      end
    end

    describe "#for" do
      it "sets intent" do
        @venues = subject.for('checkin')
        expect(@venues.options).to eq(intent: 'checkin')
      end
    end

    context "chain setter methods" do
      before do
        @venues = subject.with_category(food_category).near(latlng).above(100).top(20).search('coffee').for('specials')
      end

      it "retains options" do
        expect(@venues.options).to eq({'categoryId' => food_category, :ll => latlng, :alt => 100, :limit => 20, :query => 'coffee', :intent => 'specials'})
      end
    end

    after do
      expect(@venues).to be_instance_of(subject.class)
    end
  end

  describe "enumerate venues" do    
    it 'takes random sample' do
      venue = subject.sample
      expect(venue.nil?).to eq(false)
      expect(fetched_venues.include? venue).to eq(true)
    end

    it 'count elements' do
      expect(subject.count).to eq(fetched_venues.count)
      expect(subject.size).to eq(fetched_venues.size)
      expect(subject.length).to eq(fetched_venues.length)
    end

    context "with request" do
      subject { request }

      let(:venues) { Foursquare3::Venues.new(subject) }

      before do
        @venues = venues.with_category(food_category).near(latlng, 10).above(100, 1).top(20).search('restaurant').for('match')
      end

      it "receive #options"do
        expect(subject).to receive(:[]) do |options|
          expect(options['categoryId']).to eq(food_category)
          expect(options[:ll]).to eq(latlng)
          expect(options['llAcc']).to eq(10)
          expect(options[:alt]).to eq(100)
          expect(options['altAcc']).to eq(1)
          expect(options[:limit]).to eq(20)
          expect(options[:query]).to eq('restaurant')
          expect(options[:intent]).to eq('match')
          { 'venues' => [] }
        end
      end

      after do
        expect(@venues.to_a).to eq([])
      end
    end
  end
end