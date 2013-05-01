module Dbd
  module Graph
    class Collection

      include Helpers::ArrayCollection

      class InternalError < StandardError
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
        raise InternalError, "Only 1 collection allowed in a Graph::Collection" if self.count > 0
        super
      end

    end
  end
end
