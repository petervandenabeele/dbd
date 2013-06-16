require 'csv'

module Dbd

  ##
  # The Graph stores the Facts and ProvenanceFacts in an in-memory
  # collection structure.
  #
  # On the other hand, it acts as an "interface" that can be
  # re-implemented by other persistence mechanisms (duck typing).
  class Graph

    include Fact::Collection

    ##
    # Add a Fact, Resource or other recursive collection of facts.
    #
    # Side effect: this will set the time_stamp of the facts.
    #
    # @param [#time_stamp, #time_stamp=, #each] fact_collection A recursive collection of facts
    # @return [Graph] self
    def <<(fact_collection)
      fact_collection.each_recursively do |fact|
        enforce_strictly_monotonic_time(fact)
        super(fact)
      end
      self
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
