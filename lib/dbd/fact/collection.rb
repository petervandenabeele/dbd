module Dbd
  module Fact
    class Collection

      class OutOfOrderError < StandardError
      end

      include Helpers::ArrayCollection

      attr_reader :provenance_fact_subjects

      def initialize
        super
        @hash_by_subject = Hash.new { |h, k| h[k] = [] }
        @provenance_fact_subjects = {}
      end

      def newest_time_stamp
        newest_entry = @internal_collection.last
        newest_entry && newest_entry.time_stamp
      end

      def oldest_time_stamp
        oldest_entry = @internal_collection.first
        oldest_entry && oldest_entry.time_stamp
      end

      def <<(element)
        raise OutOfOrderError if (self.newest_time_stamp && element.time_stamp <= self.newest_time_stamp)
        index = Helpers::ArrayCollection.add_and_return_index(element, @internal_collection)
        @hash_by_subject[element.subject] << index
        self
      end

      def by_subject(fact_subject)
        @hash_by_subject[fact_subject].map{ |index| @internal_collection[index]}
      end
    end
  end
end
