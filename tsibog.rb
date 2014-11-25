require_relative 'lib/tsibog'

class Tsibog::CLI
  COORDINATES_OF = { '47East.ph' => '14.6371574,121.073077' }

  def print_details restaurant
    puts restaurant.name
    puts restaurant.address
    restaurant.operations.each do |operation|
      puts operation.to_s
    end
  end

  def initialize here = COORDINATES_OF['47East.ph']
    restaurant = Tsibog[ Tsibog.food_venues.near(here).top(20).sample.id ]
    print_details restaurant
  end
end

app = Tsibog::CLI.new
