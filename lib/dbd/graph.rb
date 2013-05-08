require 'csv'

module Dbd
  class Graph

    def initialize
      @fact_collection = Fact::Collection.new
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
