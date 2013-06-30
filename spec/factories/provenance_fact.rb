# encoding=utf-8
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
        subject: subject,
        predicate: "https://data.vandenabeele.com/ontologies/provenance#context",
        object: "public")
    end

    def self.created_by(subject = nil)
      factory_for.new(
        subject: subject,
        predicate: "https://data.vandenabeele.com/ontologies/provenance#created_by",
        object: "peter_v")
    end

    def self.original_source(subject = nil)
      factory_for.new(
        subject: subject,
        predicate: "https://data.vandenabeele.com/ontologies/provenance#original_source",
        object: "this has a comma , a newline \n and a double quote \"")
    end

    def self.created(subject = nil)
      factory_for.new(
        subject: subject,
        predicate: "dcterms:created",
        object: Time.now.utc)
    end

  end
end
