module Factories
  module ProvenanceResource

    def self.factory_for
      ::Dbd::ProvenanceResource
    end

    def self.provenance_resource
      factory_for.new(ProvenanceFact.new_subject).tap do |resource|
        resource << Factories::ProvenanceFact.context
        resource << Factories::ProvenanceFact.created_by
      end
    end

  end
end
