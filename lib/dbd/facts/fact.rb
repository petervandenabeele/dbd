module Dbd
  module Facts
    class Fact

      attr_reader :id, :time_stamp, :fact_origin_id

      def initialize(fact_origin_id)
        @id = Helpers::TempUUID.new
        @time_stamp = Time.new.utc
        @fact_origin_id = fact_origin_id
      end

    end
  end
end
