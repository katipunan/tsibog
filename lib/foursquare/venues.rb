require 'forwardable'

module Foursquare
  class Venues
    attr_reader :client, :options

    def initialize(client, options = default_options)
      @client, @options = client, options
    end

    def default_options
      {}
    end

    def categories
      (@options['categoryId'] || '').split(',')
    end

    def with_category(category)
      chain 'categoryId' => (categories << category).join(',')
    end

    def near(latlng, accuracy_in_meters = nil)
      chain blank_hash_or('llAcc', accuracy_in_meters).merge(ll: latlng)
    end

    def above(meters, accuracy_in_meters = nil) # altitude
      chain blank_hash_or('altAcc', accuracy_in_meters).merge(alt: meters)
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

    def for(checkin_or_match_or_specials)
      chain intent: checkin_or_match_or_specials
    end

    include Enumerable
    extend Forwardable

    def_delegators :fetch_venues, :each
    def_delegators :to_a, :sample

    protected

    def fetch_venues
      result = @client.search_venues(@options)
      result = result.respond_to?(:venues) ? result.venues : []
    end

    def chain new_option
      self.class.new @client, @options.merge(new_option)
    end

    def blank_hash_or(key, value)
      value.nil? ? {} : {key => value}
    end
  end
end