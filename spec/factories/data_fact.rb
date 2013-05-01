module Factories
  module DataFact

    def self.data_fact_1(fact_origin_id = nil)
      ::Dbd::Fact::DataFact.new(
        fact_origin_id || Factories::FactOrigin.me.id,
        UUIDTools::UUID.random_create,
        "http://example.org/test/name",
        "The great gatzbe")
    end
  end
end
