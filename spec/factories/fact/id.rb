module Factories
  module Fact
    module ID

      def self.factory_for
        ::Dbd::Fact::ID
      end

      def self.fixed_id
        factory_for.new(uuid: "825e44d5-af33-4858-8047-549bd813daa8")
      end
    end
  end
end
