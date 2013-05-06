module Dbd
  module Fact
    class Collection

      include Helpers::ArrayCollection

      class OutOfOrderError < StandardError
      end

      def newest_time_stamp
        newest_entry = @internal_collection.last
        newest_entry && newest_entry.time_stamp
      end

      def oldest_time_stamp
        oldest_entry = @internal_collection.first
        oldest_entry && oldest_entry.time_stamp
      end

      def <<(element)
        raise OutOfOrderError if (self.newest_time_stamp && element.time_stamp <= self.newest_time_stamp)
        super
      end

    end
  end
end
