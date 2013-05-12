require 'csv'

module Dbd

  ##
  # The Graph stores the Facts and ProvenanceFacts in an in-memory
  # collection structure.
  class Graph

    def initialize
      @fact_collection = Object.new
      @fact_collection.extend(Fact::Collection)
      @fact_collection.send(:initialize)
    end

    ##
    # Export the graph to a CSV string
    #
    # @return [String] comma separated string with double quoted cells
    def to_CSV
      CSV.generate(force_quotes: true) do |csv|
        @fact_collection.each do |fact|
          csv << fact.values
        end
      end.encode("utf-8")
    end

  end
end
