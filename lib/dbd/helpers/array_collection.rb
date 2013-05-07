module Dbd
  module Helpers
    module ArrayCollection

      include Enumerable

      def initialize
        @internal_collection = []
      end

      def each
        @internal_collection.each do |e|
          yield e
        end
      end

      def last
        @internal_collection.last
      end

      # no instance method so it is not in the API of mixin classes
      def self.add_and_return_index(element, collection)
        collection << element
        # FIXME this is "probably" thread safe, not sure about performance ...
        # FIXME I did not find a proper atomic, thread safe
        # FIXME "insert and return index of inserted element" in the
        # FIXME standard Array documentation.
        collection.rindex(element)
      end

    end
  end
end
