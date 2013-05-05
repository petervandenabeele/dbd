module Factories
  module Fact

    def self.fact_1(fact_origin_id = nil)
      ::Dbd::Fact::Base.new(
        fact_origin_id || Factories::FactOrigin.me.id,
        UUIDTools::UUID.random_create,
        "http://example.org/test/name",
        "Gandhi")
    end

    def self.fact_2(fact_origin_id = nil)
      ::Dbd::Fact::Base.new(
        fact_origin_id || Factories::FactOrigin.me.id,
        UUIDTools::UUID.random_create,
        "http://example.org/test/name",
        "Mandela")
    end

    module Collection
      def self.fact_1_2(fact_origin_id = nil)
        ::Dbd::Fact::Collection.new.tap do |facts|
          facts << Fact.fact_1(fact_origin_id)
          facts << Fact.fact_2(fact_origin_id)
        end
      end

      def self.fact_3_4(fact_origin_id = nil)
        ::Dbd::Fact::Collection.new.tap do |facts|
          # different timestamp from fact_2 above
          facts << Fact.fact_1(fact_origin_id)
          facts << Fact.fact_2(fact_origin_id)
        end
      end
    end
  end
end
