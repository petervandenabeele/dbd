module Factories
  module ProvenanceResource

    def self.factory_for
      ::Dbd::ProvenanceResource
    end

    def self.provenance_resource
      factory_for.new.tap do |provenance_resource|
        provenance_resource << Factories::ProvenanceFact.context
        provenance_resource << Factories::ProvenanceFact.created_by
      end
    end

  end
end
