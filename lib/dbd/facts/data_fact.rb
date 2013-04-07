module Dbd
  module Facts
    class DataFact

      attr_reader :id, :time_stamp

      def initialize
        @id = Helpers::TempUUID.new
        @time_stamp = Time.new.utc
      end

    end
  end
end
