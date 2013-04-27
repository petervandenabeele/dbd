module Dbd
  module Graph
    class Collection

      include Helpers::ArrayCollection

      def newest_time_stamp
        # TODO filter only fact_collections !!
        newest_entry = @internal_collection.last
        newest_entry && newest_entry.newest_time_stamp
      end

    end
  end
end
