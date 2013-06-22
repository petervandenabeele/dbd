module Dbd
  class Fact
    module ID

      def self.regexp
        Helpers::UUID.regexp
      end

      def self.new_id
        Helpers::UUID.new.to_s
      end

    end
  end
end
