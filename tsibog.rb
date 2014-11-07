require 'foursquare2'

module Tsibog
  CLIENT = Foursquare2::Client.new(:client_id => 'LQSHZK4YX3P5DTIUPRET2EDJ53SZPQSSCXG5IZXDMMQHRR0L', :client_secret => '11FO21GAOBGCIS3S5JEJADXMRH2IIVTIW4DIZANVR4LAV0JE', api_version: 20140806)

  def self.food_places_near(geodata, top = 20)
    CLIENT.search_venues(:ll => geodata, :query => 'Food', limit: top).venues
  end

  def self.food_place id
    Restaurant.new CLIENT.venue id
  end

  class Restaurant
    def initialize venue
      @venue = venue
    end

    def name
      @venue.name
    end

    def address
      @venue.location.formattedAddress.join(', ')
    end

    def operations
      timeframes.map {|tf| StoreOperation.new(tf.days, tf.open) }
    end

    private

    def timeframes
      hours ? hours.timeframes : []
    end

    def hours
      @venue.popular || @venue.hours
    end
  end

  class StoreOperation < Struct.new(:day, :open_hours)
    def to_s
       "#{day}: #{hours.join(', ')}"
    end

    def hours
      open_hours.map {|hour| hour['renderedTime'] }
    end
  end
end

class Tsibog::Application
  COORDINATES_OF = { '47East.ph' => '14.6371574,121.073077' }

  def top(limit = 20)
    Tsibog.food_places_near(COORDINATES_OF['47East.ph'], limit)
  end

  def random_select
    top(20).sample
  end

  def print_details restaurant
    puts restaurant.name
    puts restaurant.address
    restaurant.operations.each do |operation|
      puts operation.to_s
    end
  end

  def initialize
    restaurant = Tsibog.food_place random_select.id
    print_details restaurant
  end
end

app = Tsibog::Application.new
