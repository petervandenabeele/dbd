module TestFactories
  module Resource

    def self.factory_for
      ::Dbd::Resource
    end

    def self.empty(provenance_subject)
      subject = Fact.new_subject
      factory_for.new(subject: subject, provenance_subject: provenance_subject)
    end

    def self.facts_resource(provenance_subject = provenance_subject())
      subject = Fact.new_subject
      factory_for.new(subject: subject, provenance_subject: provenance_subject).tap do |resource|
        resource << TestFactories::Fact.data_fact(provenance_subject, subject)
        resource << TestFactories::Fact.data_fact_EU(provenance_subject, subject)
      end
    end

  private

    def self.provenance_subject
      TestFactories::ProvenanceResource.provenance_resource.subject
    end

  end
end
