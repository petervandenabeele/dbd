module Factories
  module FactsBySubject

    def self.provenance_facts
      ::Dbd::FactsBySubject.new.tap do |fbs|
        fbs << Factories::ProvenanceFact.context
        fbs << Factories::ProvenanceFact.created_by
      end
    end

    def self.facts_1
      ::Dbd::FactsBySubject.new.tap do |fbs|
        fbs << Factories::Fact.fact_1
        fbs << Factories::Fact.fact_2_with_subject
      end
    end

    def self.facts_2
      ::Dbd::FactsBySubject.new.tap do |fbs|
        fbs << Factories::Fact.fact_3
      end
    end

  end
end
