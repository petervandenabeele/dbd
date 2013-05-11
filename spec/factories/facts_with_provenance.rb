module Factories
  module ResourcesWithProvenance

    def self.full_factory
      ::Dbd::ResourcesWithProvenance.new(Resource.provenance_resource).
        tap do |resources_with_provenance|
          resources_with_provenance.resource_collection <<
            Resource.resource_1
          resources_with_provenance.resource_collection <<
            Resource.resource_2_3
      end
    end

  end
end
