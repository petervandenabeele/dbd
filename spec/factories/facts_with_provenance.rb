module Factories
  module FactsWithProvenance

=begin
    def provenance_facts
      FactsBySubject.new.tap do |fbs|
        fbs << Factories::ProvenanceFact.context
        fbs << Factories::ProvenanceFact.created_by
      end
    end

    def facts_1
      FactsBySubject.new.tap do |fbs|
        fbs << Factories::Fact.fact_1
        fbs << Factories::Fact.fact_2
      end
    end

    def facts_2
      FactsBySubject.new.tap do |fbs|
        fbs << Factories::Fact.fact_3
      end
    end
=end

    def self.full_factory
      ::Dbd::FactsWithProvenance.new(FactsBySubject.provenance_facts).
        tap do |facts_with_provenance|
          facts_with_provenance.facts_by_subject_collection <<
            Fact.fact_1
          facts_with_provenance.facts_by_subject_collection <<
            Fact.fact_2
      end
    end

  end
end
