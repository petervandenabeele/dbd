module Dbd
  module Facts
    class DataFact

      attr_reader :id

      def initialize
        @id = Helpers::TempUUID.new
      end

    end
  end
end
