module TestFactories
  module Graph
    def self.factory_for
      ::Dbd::Graph
    end

    def self.new_subject
      ::Dbd::Fact.factory.new_subject
    end

    def self.only_provenance
      factory_for.new << TestFactories::ProvenanceResource.provenance_resource
    end

    def self.only_facts(provenance_subject = new_subject)
      factory_for.new << TestFactories::Resource.facts_resource(provenance_subject)
    end

    def self.full
      provenance_resource = TestFactories::ProvenanceResource.provenance_resource
      resource = TestFactories::Resource.facts_resource(provenance_resource.subject)
      factory_for.new << provenance_resource << resource
    end
  end
end
