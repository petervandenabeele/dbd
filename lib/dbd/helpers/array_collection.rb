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

      def <<(element)
        @internal_collection << element
        # FIXME this is "probably" thread safe, not sure about performance ...
        # FIXME I did not find a proper atomic, thread safe
        # FIXME "insert and return index of inserted element" in the standard
        # FIXME Array documentation.
        @internal_collection.rindex(element)
      end

      def last
        @internal_collection.last
      end

      def [](index)
        @internal_collection[index]
      end

    end
  end
end
