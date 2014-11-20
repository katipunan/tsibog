require 'tsibog/venues'

describe Tsibog::Venues do
  subject { Tsibog::Venues.new(request) }

  let(:request) { Hash.new('venues' => fetched_data) }
  let(:fetched_data) { [{id: 1, name: 'Jollibee'}, {id: 2, name: 'Chowking'}, {id: 3, name: 'Mang inasal'}] }
  let(:food_category) { '4d4b7105d754a06374d81259' }
  let(:latlng) { '14.6371574,121.073077' }

  describe "#initialize" do
    context :options do
      it { expect(subject.options).to eq({}) }
    end

    context :categories do
      it { expect(subject.categories).to eq([]) }
    end
  end
  
  describe "#with_category" do
    let(:food_venues) { subject.with_category(food_category) }

    context :categories do
      it { expect(food_venues.categories).to include(food_category) }
    end

    context :options do
      it { expect(food_venues.options).to eq('categoryId' => food_category) }
    end
  end

  describe "#near" do
    context :options do
      it { expect(subject.near(latlng).options).to eq(ll: latlng) }

      describe "with accuracy in meters" do
        it { expect(subject.near(latlng, 10).options).to eq(:ll => latlng, 'llAcc' => 10) }
      end
    end
  end

  describe "#above" do
    context :options do
      it { expect(subject.above(100).options).to eq(alt: 100) }

      describe "with accuracy in meters" do
        it { expect(subject.above(100, 1).options).to eq(alt: 100, 'altAcc' => 1) }
      end
    end
  end

  describe "#within" do
    context :options do
      it { expect(subject.within(80).options).to eq(radius: 80) }
    end
  end

  describe "#top" do
    context :options do
      it { expect(subject.top(20).options).to eq(limit: 20) }
    end
  end

  describe "#search" do
    context :options do
      it { expect(subject.search('coffee').options).to eq(query: 'coffee') }
    end
  end

  describe "#for" do
    context :options do
      it { expect(subject.for('checkin').options).to eq(intent: 'checkin') }
    end
  end

  describe "when methods chained" do
    context "returned output" do
      let(:returned_output) { subject.with_category(food_category).near(latlng).above(100).top(20).search('coffee').for('specials') }

      context :options do
        it "retain inputs" do
          expect(returned_output.options).to eq('categoryId' => food_category, :ll => latlng, :alt => 100, :limit => 20, :query => 'coffee', :intent => 'specials')
        end
      end

      it { expect(returned_output).to be_instance_of(subject.class) }
    end
  end

  describe "when enumerated" do
    let(:venues) { subject.with_category(food_category).near(latlng, 10).above(100, 1).top(20).search('restaurant').for('match') }
    
    context :request do
      it "receive #options"do
        expect(request).to receive(:[]) do |options|
          expect(options).to eq(venues.options)
          { 'venues' => ['something'] }
        end
      end
    end

    after do
      expect(venues.sample).to eq('something')
    end
  end
end