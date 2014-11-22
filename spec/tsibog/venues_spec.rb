require 'tsibog/venues'

describe Tsibog::Venues do
  subject { Tsibog::Venues.new(request) }

  let(:request) { Hash.new('venues' => fetched_data) }
  let(:fetched_data) { [{id: 1, name: 'Jollibee'}, {id: 2, name: 'Chowking'}, {id: 3, name: 'Mang inasal'}] }
  
  FOOD = '4d4b7105d754a06374d81259'
  HERE = '14.6371574,121.073077'

  describe "#initialize" do
    context :options do
      it { expect(subject.options).to be_empty }
    end

    context :categories do
      it { expect(subject.categories).to be_empty }
    end

    context "when argument doesn't support []" do
      let(:request) { nil }

      it { expect{subject}.to raise_error(ArgumentError) }
    end
  end
  
  describe "#with_category" do
    let(:food_venues) { subject.with_category(FOOD) }

    context :categories do
      it { expect(food_venues.categories).to include(FOOD) }
    end

    context :options do
      it { expect(food_venues.options).to eq('categoryId' => FOOD) }
    end
  end

  describe "#near" do
    context :options do
      it { expect(subject.near(HERE).options).to eq(ll: HERE) }

      describe "with accuracy in meters" do
        it { expect(subject.near(HERE, 10).options).to eq(:ll => HERE, 'llAcc' => 10) }
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
      it { expect(subject.search('pizza').options).to eq(query: 'pizza') }
    end
  end

  describe "#for" do
    context :options do
      it { expect(subject.for('checkin').options).to eq(intent: 'checkin') }
    end
  end

  describe "when methods chained" do
    context "returned output" do
      let(:returned_output) { subject.with_category(FOOD).near(HERE).above(100).top(20).search('coffee').for('specials') }

      context :options do
        it "retain inputs" do
          expect(returned_output.options).to eq('categoryId' => FOOD, :ll => HERE, :alt => 100, :limit => 20, :query => 'coffee', :intent => 'specials')
        end
      end

      it { expect(returned_output).to be_instance_of(subject.class) }
    end
  end

  describe "when enumerated" do
    let(:venues) { subject.within(800).near(HERE, 10).above(100, 1).top(20).search('restaurant').for('match') }
    
    context :request do
      it "receive #options" do
        expect(request).to receive(:[]).with(venues.options).and_return('venues' => ['somewhere'])
      end
    end

    after do
      expect(venues.sample).to eq('somewhere')
    end
  end
end