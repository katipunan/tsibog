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
      chain 'categoryId' => (categories << category).join(',')
    end

    def near(latlng, accuracy_in_meters = nil)
      chain blank_hash_or(llAcc: accuracy_in_meters).merge(ll: latlng)
    end

    def above(meters, accuracy_in_meters = nil) # altitude
      chain blank_hash_or(altAcc: accuracy_in_meters).merge(alt: meters)
    end

    def within(meters)
      chain radius: meters
    end

    def top(quantity)
      chain limit: quantity
    end

    def search(term)
      chain query: term
    end

    def for(intent) # checkin, match, or specials.
      chain intent: intent
    end

    private

    def chain new_option
      Venues.new @client, new_option
    end

    def blank_hash_or(hash)
      hash.first.nil? ? {} : hash
    end
  end
end