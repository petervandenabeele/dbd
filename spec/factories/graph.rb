module Factories
  module Graph

    def self.factory_for
      ::Dbd::Graph
    end

    def self.new_subject
      ::Dbd::ProvenanceFact.new_subject
    end

    def self.only_provenance
      factory_for.new << Factories::Fact::Collection.provenance_facts(new_subject)
    end

  end
end
