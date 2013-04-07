module Dbd
  module Facts
    class DataFact < Fact

      def initialize(fact_origin_id, subject_id, data_property)
        super(fact_origin_id, subject_id)
        @property = data_property
      end

    end
  end
end
