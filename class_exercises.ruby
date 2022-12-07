class Gear
    attr_reader :chainring, :cog, :wheel

    def initialize(args)
        @chainring = args[:chainring]
        @cog = args[:cog]
        @wheel = args[:wheel]
    end

    def ratio
        chainring / cog.to_f
    end

    def gear_inches
        ratio * wheel.diameter
    end

    def diameter
        wheel.diameter
    end
end

class Wheel
    attr_reader :rim, :tire
    
    def initialize(rim, tire)
        @rim = rim
        @tire = tire
    end

    def diameter
        rim + (tire * 2)
    end

    def circumference
        diameter * Math::PI
    end
end

class Trip
end

class Person
end

class Mechanic
end

@wheel = Wheel.new(26, 1.5)
puts @wheel.circumference
new_gear_sample = Gear.new({:chainring => 52, :cog =>  11, :wheel =>  @wheel})
puts new_gear_sample.gear_inches
puts new_gear_sample.ratio