module TestFactories
  module TimeStamp

    def self.factory_for
      ::Dbd::TimeStamp
    end

    def self.fixed_time_string
      '2013-06-17 21:55:09.967653013 UTC'
    end

    def self.fixed_time_stamp
      factory_for.new(time: fixed_time_string)
    end
  end
end
