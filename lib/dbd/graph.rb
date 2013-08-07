require 'csv'

module Dbd

  ##
  # The Graph stores the Facts and Contexts in an in-memory
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
    # @param [#time_stamp, #time_stamp=, #each] fact_collection a recursive collection of facts
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
    # Newlines in the fields are escaped to "backslash n".
    # Backslashes in the field are escape to "double backslash".
    #
    # @return [String] comma separated string with double quoted cells
    def to_CSV
      CSV.generate(csv_defaults) do |csv|
        push_facts(csv)
      end
    end

    ##
    # Export the graph to a CSV file
    #
    # Newlines in the fields are escaped to "backslash n".
    # Backslashes in the field are escape to "double backslash".
    #
    # @param [String] filename the filename to stream the CSV to
    def to_CSV_file(filename)
      CSV.open(filename, 'w', csv_defaults) do |csv|
        push_facts(csv)
      end
    end

    ##
    # Import a graph from a CSV IO stream
    #
    # Tokens "backslash n" in the CSV fields will be unescaped to newlines.
    # Tokens "double backslash" in the CSV fields will be unescaped to single backslash
    #
    # @param [IO Stream] csv an IO Stream that contains the CSV serialization
    # @return [Graph] the imported graph
    def from_CSV(csv)
      CSV.new(csv).each do |row|
        self << Fact.factory.from_string_values(row, validate: true)
      end
      self
    end

  private

    ##
    # Setting a strictly monotonically increasing time_stamp (if not yet set).
    # The time_stamp also has some randomness (1 .. 999 ns) to reduce the
    # chance on collisions when merging fact streams from different sources.
    def enforce_strictly_monotonic_time(fact)
      fact.time_stamp = TimeStamp.new(larger_than: newest_time_stamp) unless fact.time_stamp
    end

    def csv_defaults
      {force_quotes: true,
       encoding: 'utf-8'}
    end

    def push_facts(target)
      @internal_collection.each do |fact|
        target << fact.string_values
      end
    end

  end
end
