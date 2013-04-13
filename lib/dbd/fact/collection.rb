module Dbd
  module Fact
    class Collection

      include Enumerable

      class OutOfOrderError < StandardError
      end

      def initialize()
        @internal_collection = []
      end

      def each
        @internal_collection.each do |e|
          yield e
        end
      end

      def newest_time_stamp
        newest_entry = @internal_collection.last
        newest_entry && newest_entry.time_stamp
      end

      def <<(element)
        raise OutOfOrderError if (self.newest_time_stamp && element.time_stamp <= self.newest_time_stamp)
        @internal_collection << element
      end

    end
  end
end
