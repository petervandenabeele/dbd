module Factories
  module ResourcesWithProvenance

    def self.factory_for
      ::Dbd::ResourcesWithProvenance
    end

    def self.full_factory
      factory_for.new(ProvenanceResource.provenance_resource).
        tap do |resources_with_provenance|
          resources_with_provenance << Resource.facts_resource(resources_with_provenance.provenance_resource.subject)
          resources_with_provenance << Resource.facts_resource(resources_with_provenance.provenance_resource.subject)
      end
    end

  end
end
