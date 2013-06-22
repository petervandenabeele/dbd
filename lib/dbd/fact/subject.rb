require 'dbd/helpers/uuid'

module Dbd
  class Fact
    class Subject
      include DefineEquality(:uuid)
      attr_reader :uuid

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
