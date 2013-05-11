require 'securerandom'

module Dbd
  module Helpers
    class UUID

      def self.regexp
        /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
      end

      def initialize
        @uuid = SecureRandom.uuid
      end

      def to_s
        @uuid.to_s
      end

    end
  end
end
