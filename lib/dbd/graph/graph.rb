require 'dbd/graph/to_CSV'

module Dbd
  module Graph
    class Graph

      include ToCSV

      attr_reader :collections

      def initialize
        @collections = []
      end

      def collections
        @collections.dup.freeze
      end

      def <<(entry)
        @collections << entry
      end

    end
  end
end
