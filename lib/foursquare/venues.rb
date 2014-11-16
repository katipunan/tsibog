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
  end
end