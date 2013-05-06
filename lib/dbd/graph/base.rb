require 'csv'

module Dbd
  module Graph
    class Base

      attr_reader :provenance_fact_collection, :fact_collections

      def initialize
        @provenance_fact_collections = Collection.new
        @fact_collections = Collection.new
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
          self.fact_collections.each do |fact_collection|
            fact_collection.each do |fact|
              csv << fact.values
            end
          end
        end.encode("utf-8")
      end

    end
  end
end
