module Foursquare
  class Venues
  	attr_reader :client, :options
  	def initialize(client, options = {})
  	  @client, @options = client, options
  	end
  end
end