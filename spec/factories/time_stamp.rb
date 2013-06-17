module Factories
  module TimeStamp

    def self.factory_for
      ::Dbd::TimeStamp
    end

    def self.fixed_time_stamp
      factory_for.from_s("2013-06-17 21:55:09.967653012 UTC")
    end
  end
end
