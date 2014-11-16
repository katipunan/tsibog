module Foursquare
  class Venues
  	attr_reader :client, :options

  	def initialize(client, options = {})
  	  @client, @options = client, options
  	end

  	def categories
  	  (@options['categoryId'] || '').split(',')
  	end
  end
end