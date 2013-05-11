module Factories
  module ProvenanceFact

    def self.factory_for
      ::Dbd::ProvenanceFact
    end

    def self.new_subject
      factory_for.new_subject
    end

    def self.context(subject = nil)
      factory_for.new(
        subject,
        "https://data.vandenabeele.com/ontologies/provenance#context",
        "public")

    end

    def self.created_by(subject = nil)
      factory_for.new(
        subject,
        "https://data.vandenabeele.com/ontologies/provenance#created_by",
        "peter_v")
    end

    def self.original_source(subject = nil)
      factory_for.new(
        subject,
        "https://data.vandenabeele.com/ontologies/provenance#original_source",
        "this has a comma , a newline \n and a double quote \"")
    end

  end
end
