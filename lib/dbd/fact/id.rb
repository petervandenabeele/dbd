module Dbd
  class Fact
    module ID

      def self.valid_regexp
        Helpers::UUID.valid_regexp
      end

      def self.new_id
        Helpers::UUID.new.to_s
      end

    end
  end
end
