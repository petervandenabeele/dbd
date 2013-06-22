require 'dbd/helpers/uuid'

module Dbd
  class Fact
    class Subject
      include DefineEquality(:uuid)
      attr_reader :uuid

      def initialize(options = {})
        @uuid = options[:uuid] || self.class.new_subject
      end

      def to_s
        @uuid
      end

      def self.regexp
        Helpers::UUID.regexp
      end

      def self.new_subject
        Helpers::UUID.new.to_s
      end

    end
  end
end
