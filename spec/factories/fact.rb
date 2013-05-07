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

      def self.provenance_facts(subject = nil)
        ::Dbd::Fact::Collection.new.tap do |provenance_facts|
          provenance_facts << ProvenanceFact.context(subject)
          provenance_facts << ProvenanceFact.created_by(subject)
          provenance_facts << ProvenanceFact.original_source(subject)
        end
      end
    end
  end
end
