module Dbd
  module Helpers

    ##
    # Transforms the mixing class into an OrderedSet.
    #
    # On the mixing class, enumerable functions are possible,
    # looping over the set in O(n), but it is not intended
    # that the mixing class allows arbitrary access into
    # the collection.
    #
    # The *add_and_return_index* module method allows to get
    # an index to an added element, so indexes can be
    # built to access elements in O(1). The mixing class
    # should not expose this index to the added element in
    # it's public API. The goal is to allow other
    # implementations (e.g. with Hadoop, Neo4j, ...) with
    # the same API.
    module OrderedSetCollection

      include Enumerable

      ##
      # Creates @internal_collection in the mixing class.
      def initialize
        @internal_collection = []
      end

      ##
      # Inserts an element at the end of the collection.
      # Returns self to allow chaining.
      # @param [Object] element
      # @return [Object] self
      def <<(element)
        @internal_collection << element
        self
      end

      ##
      # For the Enumerable functionality.
      def each
        @internal_collection.each do |e|
          yield e
        end
      end

      ##
      # This is required as an efficient way to find the last
      # element without stepping through the entire collection.
      # @return [Object] the last element
      def last
        @internal_collection.last
      end

      ##
      # Adds an element at the end of the collection and
      # returns the array index of that element.
      #
      # This is not an instance method to avoid it ending
      # up in the public API of classes that mixin this module.
      #
      # The implementation to find the index of the inserted
      # element with `rindex` is primitive, but I did not see
      # a better way in Ruby to do this (using `size` would
      # certainly be not thread safe, maybe the current
      # approach is thread safe, but that is not tested).
      # @return [Integer] index
      def self.add_and_return_index(element, collection)
        collection << element
        collection.rindex(element)
      end

    end
  end
end
