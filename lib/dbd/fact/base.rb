module Dbd
  module Fact
    class Base

      def self.attributes
        [:id,
         :time_stamp,
         :provenance_fact_subject,
         :subject,
         :property,
         :object]
      end

      attributes.each do |attribute|
        attr_reader attribute
      end

      def initialize(provenance_fact_subject, subject, property, object)
        @id = UUIDTools::UUID.random_create
        @time_stamp = Time.new.utc
        @provenance_fact_subject = provenance_fact_subject
        @subject = subject
        @property = property
        @object = object
      end

      def values
        self.class.attributes.map{|attribute| self.send(attribute)}
      end

    end
  end
end
