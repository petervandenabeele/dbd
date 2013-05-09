require 'dbd/helpers/uuid'

module Dbd
  module Fact
    class Subject

      def initialize
        @uuid = Helpers::UUID.new
      end

      def to_s
        @uuid.to_s
      end

      def self.regexp
        Helpers::UUID.regexp
      end

    end
  end
end
