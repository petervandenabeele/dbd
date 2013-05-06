require 'csv'

module Dbd
  module Graph
    class Base

      attr_reader :fact_collection

      def initialize
        @fact_collection = Fact::Collection.new
      end

      # Export the fact collection in a graph to a CSV
      #
      # @param (none)
      #
      # @return a comma separated CSV with double quoted strings
      #
      # @api public
      def to_CSV
        CSV.generate(force_quotes: true) do |csv|
          fact_collection.each do |fact|
            csv << fact.values
          end
        end.encode("utf-8")
      end

    end
  end
end
