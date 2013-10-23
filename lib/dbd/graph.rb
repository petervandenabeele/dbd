require 'csv'
require 'tempfile'

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
    # Import a graph from a sorted CSV IO stream
    #
    # time_stamps need to be strictly monotonic increasing
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

    ##
    # Import a graph from an unsorted CSV file (by filename)
    #
    # time_stamps need to be unique (but can be random order)
    #
    # Tokens "backslash n" in the CSV fields will be unescaped to newlines.
    # Tokens "double backslash" in the CSV fields will be unescaped to single backslash
    #
    # @param [String] filename the filename of the unsorted CSV file
    # @return [Graph] the imported graph
    def from_unsorted_CSV_file(filename)
      on_sorted_file(filename) { |sorted_file| from_CSV(sorted_file) }
    end

    ##
    # Return an array of resources for graph
    #
    # @return [Array] array with all resources
    def resources
      @resource_indices_by_subject.map do |subject, fact_indices|
        Resource.new(subject: subject) << facts_from_indices(fact_indices)
      end
    end

    ##
    # Return an array of contexts for graph
    #
    # @return [Array] array with all contexts
    def contexts
      @context_indices_by_subject.map do |subject, fact_indices|
        Context.new(subject: subject) << facts_from_indices(fact_indices)
      end
    end

  private

    ##
    # Setting a strictly monotonically increasing time_stamp (if not yet set).
    # The time_stamp also has some randomness (1 .. 999 ns) to reduce the
    # chance on collisions when merging fact streams from different sources.
    def enforce_strictly_monotonic_time(fact)
      fact.time_stamp = TimeStamp.new(larger_than: newest_time_stamp) unless fact.time_stamp
    end

    ##
    # Reach deep into the @internal_collection for the facts.
    # In later implementations with external stores, this
    # will probably change.
    def facts_from_indices(fact_indices)
      fact_indices.map do |index|
        @internal_collection[index]
      end
    end

    def csv_defaults
      { force_quotes: true,
        encoding: 'utf-8' }
    end

    ##
    # Reach deep into the @internal_collection for the facts.
    # In later implementations with external stores, this
    # will probably change.
    def push_facts(target)
      @internal_collection.each do |fact|
        target << fact.string_values
      end
    end

    ##
    # It seems that sometimes temp files are not properly
    # cleaned up.
    def on_sorted_file(filename)
      Tempfile.open('foo', 'data/') do |sorted_file|
        create_sorted_file(filename, sorted_file)
        yield(sorted_file)
      end
    end

    def create_sorted_file(filename, sorted_file)
      temp_name = sorted_file.path
      `sort #{filename} > #{temp_name}`
    end

  end
end
