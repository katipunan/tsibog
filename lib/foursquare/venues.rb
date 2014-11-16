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

    def near(latlng)
      Venues.new @client, ll: latlng
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
  end
end