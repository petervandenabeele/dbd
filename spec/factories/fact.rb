module Factories
  module Fact

    def self.fact_1(provenance_fact_id = nil)
      ::Dbd::Fact::Base.new(
        provenance_fact_id || Factories::ProvenanceFact.context.id,
        UUIDTools::UUID.random_create,
        "http://example.org/test/name",
        "Gandhi")
    end

    def self.fact_2(provenance_fact_id = nil)
      ::Dbd::Fact::Base.new(
        provenance_fact_id || Factories::ProvenanceFact.context.id,
        UUIDTools::UUID.random_create,
        "http://example.org/test/name",
        "Mandela")
    end

    module Collection
      def self.fact_1_2(provenance_fact_id = nil)
        ::Dbd::Fact::Collection.new.tap do |facts|
          facts << Fact.fact_1(provenance_fact_id)
          facts << Fact.fact_2(provenance_fact_id)
        end
      end
    end
  end
end
