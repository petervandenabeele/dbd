require 'csv'

module Dbd
  module Graph
    module ToCSV

      # Export a graph to a CSV
      #
      # @param (none)
      #
      # @return a comma separated CSV with double quoted strings
      #
      # @api public
      def to_CSV
        CSV.generate(force_quotes: true) do |csv|
          self.each do |fact_origin_collection|
            fact_origin_collection.each do |id, fact_origin|
              csv << ["abc-def-ghi", "blah foo bar", "2013-05-01 13:36:45.456893045"]
            end
          end
        end.encode("utf-8")
      end

    end
  end
end
