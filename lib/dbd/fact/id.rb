module Dbd
  class Fact
    class ID
      include DefineEquality(:uuid)
      attr_reader :uuid

      def initialize(options = {})
        @uuid = options[:uuid] || self.class.new_id
      end

      def to_s
        @uuid
      end

      def self.regexp
        Helpers::UUID.regexp
      end

      def self.new_id
        Helpers::UUID.new.to_s
      end

    end
  end
end
