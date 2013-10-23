require 'dbd/helpers/ordered_set_collection'

module Dbd
  class Fact
    module Collection

      include Helpers::OrderedSetCollection

      def initialize
        super
        @resource_indices_by_subject = {}
        @context_indices_by_subject = {}
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
        hash_entry_from_indices(fact_subject).map do |index|
          @internal_collection[index]
        end
      end

      def resource_subjects
        @resource_indices_by_subject.keys
      end

      def context_subjects
        @context_indices_by_subject.keys
      end

    private

      def hash_entry_from_indices(fact_subject)
        @resource_indices_by_subject[fact_subject] || @context_indices_by_subject[fact_subject]
      end

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
        if fact.context_fact?
          add_to_index_hash_with_default_array(@context_indices_by_subject, fact.subject, index)
        else
          add_to_index_hash_with_default_array(@resource_indices_by_subject, fact.subject, index)
        end
      end

      def add_to_index_hash_with_default_array(index_hash, subject, index)
        if (array = index_hash[subject])
          array << index
        else
          index_hash[subject] = [index]
        end
      end
    end
  end
end
