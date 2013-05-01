module Factories
  module DataFact

    def self.data_fact_1
      ::Dbd::Fact::DataFact.new(
        Factories::FactOrigin.me.id,
        UUIDTools::UUID.random_create,
        "http://example.org/test/name",
        "The great gatzbe")
    end
  end
end
