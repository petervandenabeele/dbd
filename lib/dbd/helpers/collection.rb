module Dbd
  module Helpers
    module Collection

      include Enumerable

      def initialize()
        @internal_collection = []
      end

      def each
        @internal_collection.each do |e|
          yield e
        end
      end

      def <<(element)
        @internal_collection << element
      end

    end
  end
end
