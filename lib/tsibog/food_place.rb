module Tsibog
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