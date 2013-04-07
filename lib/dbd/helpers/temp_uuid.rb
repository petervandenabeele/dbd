module Dbd
  module Helpers
    class TempUUID

      attr_reader :value

      def initialize
        @value = (Random.rand * (2**64)).to_i
      end

    end
  end
end
