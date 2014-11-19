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

  context "when options are set" do
    describe "#with_category" do
      let(:food_venue) { subject.with_category(food_category) }

      it "sets #categories to include category" do
        expect(food_venue.categories).to include(food_category)
      end

      it "sets category id" do
        expect(food_venue.options).to eq('categoryId' => food_category)
      end
    end

    describe "#near" do
      it "sets geolocation" do
        expect(subject.near(latlng).options).to eq(ll: latlng)
      end

      it "sets geolocation with accuracy" do
        expect(subject.near(latlng, 10).options).to eq(:ll => latlng, 'llAcc' => 10)
      end
    end

    describe "#above" do
      it "sets altitude" do
        expect(subject.above(100).options).to eq(alt: 100)
      end

      it "sets altitude with accuracy" do
        expect(subject.above(100, 1).options).to eq(alt: 100, 'altAcc' => 1)
      end
    end

    describe "#within" do
      it "sets radius" do
        expect(subject.within(80).options).to eq(radius: 80)
      end
    end

    describe "#top" do
      it "sets limit" do
        expect(subject.top(20).options).to eq(limit: 20)
      end
    end

    describe "#search" do
      it "sets query" do
        expect(subject.search('coffee').options).to eq(query: 'coffee')
      end
    end

    describe "#for" do
      it "sets intent" do
        expect(subject.for('checkin').options).to eq(intent: 'checkin')
      end
    end

    context "chain setter methods" do
      before do
        @venues = subject.with_category(food_category).near(latlng).above(100).top(20).search('coffee').for('specials')
      end

      it "retains options" do
        expect(@venues.options).to eq('categoryId' => food_category, :ll => latlng, :alt => 100, :limit => 20, :query => 'coffee', :intent => 'specials')
      end

      after do
        expect(@venues).to be_instance_of(subject.class)
      end
    end
  end

  describe "when venues are enumerated" do
    it 'takes random sample' do
      expect(fetched_venues).to include(subject.sample)
    end

    it 'count elements' do
      expect(subject.count).to eq(fetched_venues.count)
      expect(subject.size).to eq(fetched_venues.size)
      expect(subject.length).to eq(fetched_venues.length)
    end

    context "the request" do
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