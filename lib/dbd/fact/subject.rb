require 'dbd/helpers/uuid'

module Dbd
  class Fact
    module Subject

      def self.regexp
        Helpers::UUID.regexp
      end

      def self.new_subject
        Helpers::UUID.new.to_s
      end

    end
  end
end
