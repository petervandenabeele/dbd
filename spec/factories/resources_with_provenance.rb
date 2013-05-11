module Factories
  module ResourcesWithProvenance

    def self.factory_for
      ::Dbd::ResourcesWithProvenance
    end

    def self.full_factory
      factory_for.new(Resource.provenance_resource).
        tap do |resources_with_provenance|
          resources_with_provenance.resource_collection <<
            Resource.facts_resource
          resources_with_provenance.resource_collection <<
            Resource.facts_resource
      end
    end

  end
end
