module Dbd
  module Fact
    class Fact

      attr_reader :id, :time_stamp, :fact_origin_id, :subject_id, :property, :object

      def initialize(fact_origin_id, subject_id)
        @id = Helpers::TempUUID.new
        @time_stamp = Time.new.utc
        @fact_origin_id = fact_origin_id
        @subject_id = subject_id
      end

    end
  end
end
