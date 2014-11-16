module Foursquare
  class Venues
  	attr_reader :client
  	def initialize(client)
  	  @client = client
  	end
  end
end