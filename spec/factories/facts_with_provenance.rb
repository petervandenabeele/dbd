module Factories
  module FactsWithProvenance

    def self.full_factory
      ::Dbd::FactsWithProvenance.new(FactsBySubject.provenance_facts).
        tap do |facts_with_provenance|
          facts_with_provenance.facts_by_subject_collection <<
            Fact.fact_1
          facts_with_provenance.facts_by_subject_collection <<
            Fact.fact_2_with_subject
      end
    end

  end
end
