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
# class Bicycle
#     attr_reader :size, :chain, :tire_size

#     def initialize(args)
#         @size = args[:size]
#         @chain = args[:chain] || default_chain
#         @tire_size = args[:tire_size] || default_tire_size
#         post_initialize(args)
#     end

#     def post_initialize(args)
#         nil
#     end

#     def spares 
#         {
#             tire_size: tire_size,
#             chain: chain
#         }.merge(local_spares)
#     end

#     def local_spares
#         {}
#     end

#     def default_chain
#         '10-speed'
#     end

#     def default_tire_size
#         raise NotImplementedError
#     end
# end

# class RoadBike < Bicycle
#     attr_reader :tape_color

#     def initialize(args)
#         @tape_color = args[:tape_color]
#     end

#     def local_spares
#         {tape_color: tape_color}
#     end

#     def default_tire_size
#         '23'
#     end
# end


# class MountainBike < Bicycle
#     attr_reader :front_shock, :rear_shock

#     def initialize(args)
#         @front_shock = args[:front_shock]
#         @rear_shock = args[:rear_shock]
#     end

#     def local_spares
#         {rear_shock: rear_shock}
#     end

#     def default_tire_size
#         '2.1'
#     end
# end

# class RecumbantBike < Bicycle
#     attr_reader :flag

#     def post_initialize(args)
#         @flag = args[:flag]
#     end

#     def local_spares
#         {flag: flag}
#     end

#     def default_chain
#         "9-speed"
#     end
    
#     def default_tire_size
#         '28'
#     end
# end

# laydown_bike = RecumbantBike.new(flag: "american")
# puts laydown_bike.spares


# chapter 7


# class Schedule
#     def scheduled?(schedulable, start_date, end_date)
#         puts "This #{schedulable.class} " + 
#         "is not schedulable\n" + 
#         " between #{start_date} and #{end_date}."
#         false
#     end
# end

# module Schedulable
#     def schedule 
#         @schedule ||= ::Schedule.new
#     end

#     def schedulable?(start_date, end_date)
#         !scheduled?(start_date - lead_days, end_date)
#     end

#     def scheduled?(start_date, end_date)
#         schedule.scheduled?(self, start_date, end_date)
#     end

#     def lead_days
#         1
#     end
# end


# class Bicycle
#     attr_reader :schedule, :size, :chain, :tire_size

#     def initialize(args)
#         @schedule = args[:schedule] || Schedule.new
#         @size = args[:size]
#         @chain = args[:chain] || default_chain
#         @tire_size = args[:tire_size] || default_tire_size
#         post_initialize(args)
#     end

#     include Schedulable

#     # def schedulable?(start_date, end_date)
#     #     !scheduled?(start_date - lead_days, end_date)
#     # end

#     # def scheduled?(start_date, end_date)
#     #     schedule.scheduled?(self, start_date, end_date)
#     # end

#     def lead_days
#         1
#     end

#     def post_initialize(args)
#         nil
#     end

#     def spares 
#         {
#             tire_size: tire_size,
#             chain: chain
#         }.merge(local_spares)
#     end

#     def local_spares
#         {}
#     end

#     def default_chain
#         '10-speed'
#     end

#     def default_tire_size
#         raise NotImplementedError
#     end
# end


# class Vehicle
#     include Schedulable
    
#     def lead_days
#         3
#     end
# end

# class Mechanic
#     include Schedulable

#     def lead_days
#         4
#     end
# end

# require 'date'
# starting = Date.parse("2015/09/04")
# ending = Date.parse("2015/09/10")
# b = Bicycle.new({size: 'M', tire_size: 'L'})
# b.schedulable?(starting, ending)

# v = Vehicle.new
# v.schedulable?(starting, ending)

# m = Mechanic.new
# m.schedulable?(starting, ending)

# chapter 8
class Bicycle
    attr_reader :size, :parts

    def initialize(args={})
        @size = args[:size]
        @parts = args[:parts]
    end

    def spares 
        parts.spares
    end
end

require 'forwardable'
class Parts
    extend Forwardable
    def_delegators :@parts, :size, :each
    include Enumerable

    def initialize(parts)
        @parts = parts
    end

    def spares
        select { |part| part.needs_spare }
    end
end

require 'ostruct'
module PartsFactory
    def self.build(config, parts_class = Parts)
        parts_class.new(config.collect { |part_config| 
            create_part(part_config) })
    end

    def self.create_part(part_config)
        OpenStruct.new(name: part_config[0], description: part_config[1], needs_spare: part_config.fetch(2, true))
    end
end

road_config = [['chain', '10-speed'], ['tire_size', '23'], ['tape_color', 'red']]
mountain_config = [['chain', '10-speed'], ['tire_size', '2.1'], ['front_shock', 'Manitou', false], ['rear_shock', 'Fox']]
recumbent_config = [['chain', '11-speed'], ['tire_size', '22'], ['tape_color', 'blue']]
road_bike = Bicycle.new(size: "S", parts: PartsFactory.build(road_config))
mountain_bike = Bicycle.new(size: "L", parts: PartsFactory.build(mountain_config))
recumbant_bike = Bicycle.new(size: "M", parts: PartsFactory.build(recumbent_config))