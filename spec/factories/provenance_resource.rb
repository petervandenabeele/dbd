module Factories
  module ProvenanceResource

    def self.factory_for
      ::Dbd::ProvenanceResource
    end

    def self.provenance_resource
      provenance_subject = ProvenanceFact.new_subject
      factory_for.new(provenance_subject).tap do |resource|
        resource << Factories::ProvenanceFact.context(provenance_subject)
        resource << Factories::ProvenanceFact.created_by(provenance_subject)
      end
    end

  end
end
