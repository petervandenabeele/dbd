module Factories
  module ProvenanceFact

    def self.uuid_subject
      ::Dbd::Helpers::UUID.new
    end

    def self.context(subject = nil)
      ::Dbd::ProvenanceFact.new(
        nil,
        subject || uuid_subject,
        "https://data.vandenabeele.com/ontologies/provenance#context",
        "public")

    end

    def self.created_by(subject = nil)
      ::Dbd::ProvenanceFact.new(
        nil,
        subject || uuid_subject,
        "https://data.vandenabeele.com/ontologies/provenance#created_by",
        "peter_v")
    end

    def self.original_source(subject = nil)
      ::Dbd::ProvenanceFact.new(
        nil,
        subject || uuid_subject,
        "https://data.vandenabeele.com/ontologies/provenance#original_source",
        "this has a comma , a newline \n and a double quote \"")
    end

  end
end
