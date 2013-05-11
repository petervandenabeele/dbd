module Factories
  module FactsWithProvenance

    def self.full_factory
      ::Dbd::FactsWithProvenance.new(Resource.provenance_resource).
        tap do |facts_with_provenance|
          facts_with_provenance.resource_collection <<
            Resource.resource_1
          facts_with_provenance.resource_collection <<
            Resource.resource_2_3
      end
    end

  end
end
