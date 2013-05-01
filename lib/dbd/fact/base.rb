module Dbd
  module Fact
    class Base

      def self.attributes
        [:id, :time_stamp, :fact_origin_id, :subject_id, :property, :object]
      end

      attributes.each do |attribute|
        attr_reader attribute
      end

      def initialize(fact_origin_id, subject_id)
        @id = UUIDTools::UUID.random_create
        @time_stamp = Time.new.utc
        @fact_origin_id = fact_origin_id
        @subject_id = subject_id
      end

      def values
        self.class.attributes.map{|attribute| self.send(attribute)}
      end

    end
  end
end
