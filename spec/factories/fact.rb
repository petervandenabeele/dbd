module Factories
  module Fact

    def self.fact_1
      ::Dbd::Fact::Base.new(
        Factories::FactOrigin.me.id,
        UUIDTools::UUID.random_create)
    end

    def self.fact_2
      ::Dbd::Fact::Base.new(
        Factories::FactOrigin.me.id,
        UUIDTools::UUID.random_create)
    end

    module Collection
      def self.fact_1_2
        ::Dbd::Fact::Collection.new.tap do |facts|
          facts << Fact.fact_1
          facts << Fact.fact_2
        end
      end

      def self.fact_3_4
        ::Dbd::Fact::Collection.new.tap do |facts|
          facts << Fact.fact_1 # different timestamp from fact_1 above
          facts << Fact.fact_2 # different timestamp from fact_2 above
        end
      end
    end
  end
end
