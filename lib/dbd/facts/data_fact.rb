module Dbd
  module Facts
    class DataFact < Fact

      def initialize(fact_origin_id, subject_id, data_property, object)
        super(fact_origin_id, subject_id)
        @property = data_property
        @object = object
      end

    end
  end
end
