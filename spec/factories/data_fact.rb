module Factories
  module DataFact

    def self.data_fact_1(fact_origin_id = nil)
      ::Dbd::Fact::DataFact.new(
        fact_origin_id || Factories::FactOrigin.me.id,
        UUIDTools::UUID.random_create,
        "http://example.org/test/name",
        "The great gatzbe")
    end

    def self.data_fact_2(fact_origin_id = nil)
      ::Dbd::Fact::DataFact.new(
        fact_origin_id || Factories::FactOrigin.me.id,
        UUIDTools::UUID.random_create,
        "http://example.org/test/name",
        "Superman")
    end

    module Collection
      def self.data_fact_1_2(fact_origin_id = nil)
        ::Dbd::Fact::Collection.new.tap do |facts|
          facts << DataFact.data_fact_1(fact_origin_id)
          facts << DataFact.data_fact_2(fact_origin_id)
        end
      end
    end
  end
end
