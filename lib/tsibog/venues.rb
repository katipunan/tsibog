require 'forwardable'

module Tsibog
  class Venues
    def initialize(request)
      raise ArgumentError, ":request must respond to []" unless request.respond_to?(:[])
      @request = request
    end

    def options
      @options ||= {}
    end

    def categories
      (options['categoryId'] || '').split(',')
    end

    def with_category(category)
      chain 'categoryId' => (categories << category).join(',')
    end

    def near(latlng, accuracy_in_meters = nil)
      chain empty_or('llAcc', accuracy_in_meters).merge(ll: latlng)
    end

    def above(meters, accuracy_in_meters = nil) # altitude
      chain empty_or('altAcc', accuracy_in_meters).merge(alt: meters)
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

    def_delegators :request_venues, :each
    def_delegators :to_a, :sample, :length, :size

    protected

    def request_venues
      @request[options]['venues']
    end

    def chain(new_option)
      (duplicate = dup).options.merge! new_option
      duplicate
    end

    def empty_or(key, value)
      value.nil? ? {} : {key => value}
    end
  end
end