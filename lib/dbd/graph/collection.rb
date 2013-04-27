module Dbd
  module Graph
    class Collection

      include Helpers::ArrayCollection

      class OutOfOrderError < StandardError
      end

      def newest_time_stamp
        newest_entry = @internal_collection.select{|e| e.is_ordered?}.last
        newest_entry && newest_entry.newest_time_stamp
      end

      def oldest_time_stamp
        oldest_entry = @internal_collection.select{|e| e.is_ordered?}.first
        oldest_entry && oldest_entry.oldest_time_stamp
      end

      def <<(e)
        raise OutOfOrderError if (self.newest_time_stamp &&
                                  e.is_ordered? &&
                                  e.oldest_time_stamp <= self.newest_time_stamp)
        super
      end

    end
  end
end
