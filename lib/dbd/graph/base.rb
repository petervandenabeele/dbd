require 'csv'

module Dbd
  module Graph
    class Base

      attr_reader :fact_origin_collections, :fact_collections

      def initialize
        @fact_origin_collections = Collection.new
        @fact_collections = Collection.new
      end

      # Export the fact_origin collection in a graph to a CSV
      #
      # @param (none)
      #
      # @return a comma separated CSV with double quoted strings
      #
      # @api public
      def to_fact_origin_CSV
        CSV.generate(force_quotes: true) do |csv|
          self.fact_origin_collections.each do |fact_origin_collection|
            fact_origin_collection.each do |id, fact_origin|
              csv << fact_origin.values
            end
          end
        end.encode("utf-8")
      end

      # Export the fact collection in a graph to a CSV
      #
      # @param (none)
      #
      # @return a comma separated CSV with double quoted strings
      #
      # @api public
      def to_fact_CSV
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
