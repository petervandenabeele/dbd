module Dbd
  module Helpers
    module HashCollection

      include Enumerable

      def initialize()
        @internal_collection = {}
      end

      def each
        @internal_collection.each do |k,v|
          yield(k,v)
        end
      end

      def <<(element)
        @internal_collection[element.id] = element
      end


      def [](key)
        @internal_collection[key]
      end
    end
  end
end
