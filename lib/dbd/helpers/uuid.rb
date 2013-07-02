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
        /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\Z/
      end

      ##
      # Store a SecureRandom.uuid.
      # @return [void]
      def initialize
        @uuid = SecureRandom.uuid.encode('utf-8')
      end

      ##
      # The to_s of the uuid.
      # @return [String]
      def to_s
        @uuid
      end

    end
  end
end
