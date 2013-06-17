module Dbd
  class Fact
    class ID

      def initialize(options = {})
        @uuid = options[:uuid] || Helpers::UUID.new.to_s
      end

      def to_s
        @uuid
      end

      def self.regexp
        Helpers::UUID.regexp
      end

    end
  end
end
