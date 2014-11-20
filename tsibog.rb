require 'foursquare2'

module Tsibog
  CLIENT = Foursquare2::Client.new(:client_id => 'LQSHZK4YX3P5DTIUPRET2EDJ53SZPQSSCXG5IZXDMMQHRR0L', :client_secret => '11FO21GAOBGCIS3S5JEJADXMRH2IIVTIW4DIZANVR4LAV0JE', api_version: 20140806)
  FOOD = '4d4b7105d754a06374d81259'  

  MAX_RADIUS = 100_000 # meters away
  WALKING_DISTANCE = 80 # meters or 1 minute walk
  TEN_MINUTES_AWAY = WALKING_DISTANCE * 10 # minutes

  def self.food_places_near(geodata, top = 20)
    CLIENT.search_venues(:ll => geodata, :limit => top, 'categoryId' => FOOD, :radius => TEN_MINUTES_AWAY).venues
  end

  def self.food_place id
    FoodPlace.new CLIENT.venue id
  end

  class FoodPlace
    def initialize venue
      @venue = venue
    end

    def id
      @venue.id
    end

    def name
      @venue.name
    end

    def address
      @venue.location.address
    end

    def full_address
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
      @venue.hours || @venue.popular
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

  def initialize id = random_select.id
    restaurant = Tsibog.food_place id
    print_details restaurant
  end
end

app = Tsibog::Application.new
