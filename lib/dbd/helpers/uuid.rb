require 'securerandom'

module Dbd
  module Helpers

    ##
    # A simple UUID implementation based on SecureRandom.
    class UUID

      ##
      # A regexp that can be used in tests.
      # @return [Regexp]
      def self.regexp
        /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
      end

      ##
      # Store a SecureRandom.uuid.
      # @return [void]
      def initialize
        @uuid = SecureRandom.uuid
      end

      ##
      # The to_s of the uuid.
      # @return [String]
      def to_s
        @uuid.to_s
      end

    end
  end
end
