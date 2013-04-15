module Dbd
  module Fact
    class Collection

      include Helpers::ArrayCollection

      class OutOfOrderError < StandardError
      end

      def initialize()
        super
      end

      def newest_time_stamp
        newest_entry = @internal_collection.last
        newest_entry && newest_entry.time_stamp
      end

      def <<(element)
        raise OutOfOrderError if (self.newest_time_stamp && element.time_stamp <= self.newest_time_stamp)
        super
      end

    end
  end
end
