module Dbd
  module Graph
    class Collection

      include Helpers::ArrayCollection

      def newest_time_stamp
        # TODO filter only fact_collections !!
        newest_entry = @internal_collection.last
        newest_entry && newest_entry.newest_time_stamp
      end

      def oldest_time_stamp
        # TODO filter only fact_collections !!
        oldest_entry = @internal_collection.first
        oldest_entry && oldest_entry.oldest_time_stamp
      end

    end
  end
end
