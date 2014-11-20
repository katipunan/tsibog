require 'foursquare2'

require_relative 'tsibog/venues'

module Tsibog
  CLIENT = Foursquare2::Client.new(:client_id => 'LQSHZK4YX3P5DTIUPRET2EDJ53SZPQSSCXG5IZXDMMQHRR0L', :client_secret => '11FO21GAOBGCIS3S5JEJADXMRH2IIVTIW4DIZANVR4LAV0JE', api_version: 20140806)
  FOOD = '4d4b7105d754a06374d81259'  

  MAX_RADIUS = 100_000 # meters away
  WALKING_DISTANCE = 80 # meters or 1 minute walk
  TEN_MINUTES_AWAY = WALKING_DISTANCE * 10 # minutes

  def self.food_venues
    Venues.new(CLIENT.method :search_venues).with_category(FOOD).within(TEN_MINUTES_AWAY)
  end

  def self.[](id)
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
