require 'foursquare3/venues'

describe Foursquare3::Venues do
  subject(:venues) { Foursquare3::Venues.new(request) }

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

  context "chain methods" do
    describe "#with_category" do
      before do
        @venues = subject.with_category(food_category)
      end

      it "#categories include food_category" do
        expect(@venues.categories.include? food_category).to eq(true)
      end

      it "sets #options['categoryId'] to food_category" do
        expect(@venues.options['categoryId']).to eq(food_category)
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
      expect(@venues.class).to eq(subject.class)
    end
  end

  describe "Enumerate venues" do    
    it 'random selects a venue' do
      venue = subject.sample
      expect(venue.nil?).to eq(false)
      expect(fetched_venues.include? venue).to eq(true)
    end

    it 'count venues' do
      expect(subject.count).to eq(fetched_venues.count)
      expect(subject.size).to eq(fetched_venues.size)
      expect(subject.length).to eq(fetched_venues.length)
    end

    context "with request" do
      before do
        @venues = venues.with_category(food_category).near(latlng, 10).above(100, 1).top(20).search('restaurant').for('match')
      end      

      it "receive venues#options"do
        expect(request).to receive(:[]) do |options|
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