require 'secureRandom'

module Dbd
  module Helpers
    class UUID

      def self.regexp
        /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
      end

      def initialize
        @value = SecureRandom.uuid
      end

      def to_s
        @value.to_s
      end

    end
  end
end
