module Dbd
  module Fact
    class Base

      def self.attributes
        [:id,
         :time_stamp,
         :provenance_fact_subject,
         :subject,
         :predicate,
         :object]
      end

      attributes.each do |attribute|
        attr_reader attribute
      end

      def self.new_subject
        Subject.new
      end

      def random_uuid
        Helpers::UUID.new
      end

      def initialize(provenance_fact_subject, subject, predicate, object)
        @id = random_uuid
        @provenance_fact_subject = provenance_fact_subject
        @subject = subject
        @predicate = predicate
        @object = object
      end

      def values
        self.class.attributes.map{ |attribute| self.send(attribute) }
      end

      def update_provenance_fact_subjects(h)
        # using a provenance_fact_subject sets the key
        h[provenance_fact_subject] = true
      end

    end
  end
end
