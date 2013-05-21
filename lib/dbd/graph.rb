require 'csv'

module Dbd

  ##
  # The Graph stores the Facts and ProvenanceFacts in an in-memory
  # collection structure.
  class Graph

    include Fact::Collection

    def <<(fact)
      enforce_strictly_monotonic_time(fact)
      super(fact)
    end

    ##
    # Export the graph to a CSV string
    #
    # @return [String] comma separated string with double quoted cells
    def to_CSV
      CSV.generate(force_quotes: true) do |csv|
        @internal_collection.each do |fact|
          csv << fact.values
        end
      end.encode("utf-8")
    end

  private

    ##
    # Setting a strictly monotonically increasing time_stamp (if not yet set).
    # The time_stamp also has some randomness (1 .. 999 ns) to reduce the
    # chance on collisions when merging fact streams from different sources.
    def enforce_strictly_monotonic_time(fact)
      fact.time_stamp = TimeStamp.new(larger_than: newest_time_stamp) unless fact.time_stamp
    end

  end
end
