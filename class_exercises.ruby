# Law of Demeter heuristic: "only talk to immediate neighbors" or "only use one dot"

# class Gear
#     attr_reader :chainring, :cog, :wheel

#     def initialize(args)
#         @chainring = args[:chainring]
#         @cog = args[:cog]
#         @wheel = args[:wheel]
#     end

#     def ratio
#         chainring / cog.to_f
#     end

#     def gear_inches
#         ratio * wheel.diameter
#     end

#     def diameter
#         wheel.diameter
#     end
# end

# class Wheel
#     attr_reader :rim, :tire
    
#     def initialize(rim, tire)
#         @rim = rim
#         @tire = tire
#     end

#     def diameter
#         rim + (tire * 2)
#     end

#     def circumference
#         diameter * Math::PI
#     end
# end

# # duck typing: each class should know how to prepare for the bicycle trip

# # pre duck typing
# class Trip
#     attr_reader :bicycles, :customers, :vehicle

#     def prepare(mechanic)
#         mechanic.prepare_bicycles(bicycles)
#     end
# end

# class Mechanic
#     def prepare_bicycles(bicycles)
#         bicycles.each { |bicycle| prepare_bicycles(bicycle) }
#     end

#     def prepare_bicycle(bicycle)
#         # do something to bycicle 
#     end
# end

# # same classes, but post duck typing
# # each class has a subsequent prepare_trip method
# class Trip
#     attr_reader :bicycles, :customers, :vehicle

#     def prepare(preparers)
#         preparers.each { |preparer| prep.prepare_trip(self) }
#     end
# end

# class Mechanic
#     def prepare_trip(trip)
#         trip.bicycles.each { |bicycle| prepare_bicycle(bicycle) }
#     end

#     def prepare_bicycle(bicycle)
#         # do something to bicycle 
#     end
# end

# class TripFinder
#     def prepare_trip(trip)
#         buy_food(trip.customers)
#     end
# end

# class Driver
#     def prepare_trip(trip)
#         vehicle = trip.vehicle
#         gas_up(vehicle)
#         fill_water_tank(vehicle)
#     end
# end

# chapter 6
class Bicycle
    attr_reader :size, :chain, :tire_size

    def initialize(args)
        @size = args[:size]
        @chain = args[:chain] || default_chain
        @tire_size = args[:tire_size] || default_tire_size
        post_initialize(args)
    end

    def post_initialize(args)
        nil
    end

    def spares 
        {
            tire_size: tire_size,
            chain: chain
        }.merge(local_spares)
    end

    def local_spares
        {}
    end

    def default_chain
        '10-speed'
    end

    def default_tire_size
        raise NotImplementedError
    end
end

class RoadBike < Bicycle
    attr_reader :tape_color

    def initialize(args)
        @tape_color = args[:tape_color]
    end

    def local_spares
        {tape_color: tape_color}
    end

    def default_tire_size
        '23'
    end
end


class MountainBike < Bicycle
    attr_reader :front_shock, :rear_shock

    def initialize(args)
        @front_shock = args[:front_shock]
        @rear_shock = args[:rear_shock]
    end

    def local_spares
        {rear_shock: rear_shock}
    end

    def default_tire_size
        '2.1'
    end
end

class RecumbantBike < Bicycle
    attr_reader :flag

    def post_initialize(args)
        @flag = args[:flag]
    end

    def local_spares
        {flag: flag}
    end

    def default_chain
        "9-speed"
    end
    
    def default_tire_size
        '28'
    end
end

laydown_bike = RecumbantBike.new(flag: "american")
puts laydown_bike.spares