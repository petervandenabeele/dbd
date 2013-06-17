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

    def self.full
      provenance_resource = Factories::ProvenanceResource.provenance_resource
      resource = Factories::Resource.facts_resource(provenance_resource.subject)
      factory_for.new << provenance_resource << resource
    end

  end
end
