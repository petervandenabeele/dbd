module Dbd
  module Helpers
    module OrderedSetCollection

      include Enumerable

      def initialize
        @internal_collection = []
      end

      def <<(element)
        @internal_collection << element
        self
      end

      def each
        @internal_collection.each do |e|
          yield e
        end
      end

      def last
        @internal_collection.last
      end

      # no instance method to avoid it in the API of mixin classes
      def self.add_and_return_index(element, collection)
        collection << element
        collection.rindex(element)
      end

    end
  end
end
