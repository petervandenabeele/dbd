module Factories
  module ProvenanceFact

    def self.random_subject
      UUIDTools::UUID.random_create
    end

    def self.context(subject = nil)
      ::Dbd::ProvenanceFact::Base.new(
        nil,
        subject || random_subject,
        "https://data.vandenabeele.com/ontologies/provenance#context",
        "public")

    end

    def self.created_by(subject = nil)
      ::Dbd::ProvenanceFact::Base.new(
        nil,
        subject || random_subject,
        "https://data.vandenabeele.com/ontologies/provenance#created_by",
        "peter_v")
    end

    def self.original_source(subject = nil)
      ::Dbd::ProvenanceFact::Base.new(
        nil,
        subject || random_subject,
        "https://data.vandenabeele.com/ontologies/provenance#original_source",
        "this has a comma , a newline \n and a double quote \"")
    end

    module Collection
      def self.me(subject = nil)
        ::Dbd::Fact::Collection.new.tap do |provenance_facts|
          provenance_facts << ProvenanceFact.context(subject)
          provenance_facts << ProvenanceFact.created_by(subject)
          provenance_facts << ProvenanceFact.original_source(subject)
        end
      end
    end
  end
end
