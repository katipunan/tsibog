module Foursquare
  class Venues
    attr_reader :client, :options

    def initialize(client, options = {})
      @client, @options = client, options
    end

    def categories
      (@options['categoryId'] || '').split(',')
    end

    def with_category(category)
      Venues.new @client, 'categoryId' => (categories << category).join(',')
    end

    def near(latlng, accuracy_in_meters = nil)
      Venues.new @client, blank_hash_or(llAcc: accuracy_in_meters).merge(ll: latlng)
    end

    def above(meters, accuracy_in_meters = nil) # altitude
      Venues.new @client, blank_hash_or(altAcc: accuracy_in_meters).merge(alt: meters)
    end

    def within(meters)
      Venues.new @client, radius: meters
    end

    def top(quantity)
      Venues.new @client, limit: quantity
    end

    def search(term)
      Venues.new @client, query: term
    end

    def for(intent) # checkin, match, or specials.
      Venues.new @client, intent: intent
    end

    private

    def blank_hash_or(hash)
      hash.first.nil? ? {} : hash
    end
  end
end