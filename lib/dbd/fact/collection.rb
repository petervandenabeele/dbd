require 'dbd/helpers/ordered_set_collection'

module Dbd
  class Fact
    module Collection

      include Helpers::OrderedSetCollection

      def initialize
        super
        @hash_by_subject = Hash.new { |h, k| h[k] = [] }
        @resource_indices_by_subject = Hash.new { |h, k| h[k] = [] }
        @context_indices_by_subject = Hash.new { |h, k| h[k] = [] }
      end

      def newest_time_stamp
        newest_entry = @internal_collection.last
        newest_entry && newest_entry.time_stamp
      end

      def oldest_time_stamp
        oldest_entry = @internal_collection.first
        oldest_entry && oldest_entry.time_stamp
      end

      ##
      # This is the central method of Fact::Collection module
      #
      # @param [Fact] fact the fact that is added to the collection
      #
      # @return [self] for chaining
      #
      # Validates that added fact is valid (has no errors).
      #
      # Validates that added fact is newer.
      #
      # Adds the fact and return the index in the collection.
      #
      # Store this index in the hash_by_subject.
      def <<(fact)
        raise FactError, "#{fact.errors.join(', ')}." unless fact.errors.empty?
        validate_time_stamp(fact)
        add_to_collection(fact)
        self
      end

      def by_subject(fact_subject)
        @hash_by_subject[fact_subject].map{ |index| @internal_collection[index]}
      end

      def subjects
        @hash_by_subject.keys
      end

      def resource_subjects
        @resource_indices_by_subject.keys
      end

      def context_subjects
        @context_indices_by_subject.keys
      end

    private

      def validate_time_stamp(fact)
        if (newest_time_stamp && fact.time_stamp <= newest_time_stamp)
          raise OutOfOrderError, "time_stamp of fact was too old : #{fact.time_stamp}"
        end
      end

      def add_to_collection(fact)
        index = Helpers::OrderedSetCollection.add_and_return_index(fact, @internal_collection)
        add_to_index_hash(fact, index)
      end

      def add_to_index_hash(fact, index)
        @hash_by_subject[fact.subject] << index
        if fact.context_fact?
          @context_indices_by_subject[fact.subject] << index
        else
          @resource_indices_by_subject[fact.subject] << index
        end
      end
    end
  end
end
