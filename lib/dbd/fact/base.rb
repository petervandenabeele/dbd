module Dbd
  module Fact
    class Base

      attr_reader :id, :time_stamp, :fact_origin_id, :subject_id, :property, :object

      def initialize(fact_origin_id, subject_id)
        @id = UUIDTools::UUID.random_create
        @time_stamp = Time.new.utc
        @fact_origin_id = fact_origin_id
        @subject_id = subject_id
      end

    end
  end
end
