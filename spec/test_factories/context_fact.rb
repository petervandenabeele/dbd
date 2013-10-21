# encoding=utf-8
module TestFactories
  module ContextFact
    def self.factory_for
      ::Dbd::ContextFact
    end

    def self.new_subject
      factory_for.factory.new_subject
    end

    def self.visibility(subject = nil)
      factory_for.new(
        subject: subject,
        predicate: 'context:visibility',
        object_type: 's',
        object: 'public')
    end

    def self.created_by(subject = nil)
      factory_for.new(
        subject: subject,
        predicate: 'dcterms:creator',
        object_type: 's',
        object: 'peter_v')
    end

    def self.original_source(subject = nil)
      factory_for.new(
        subject: subject,
        predicate: 'prov:source',
        object_type: 's',
        object: "this has a comma , a newline \n and a double quote \"")
    end

    def self.created(subject = nil)
      factory_for.new(
        subject: subject,
        predicate: 'dcterms:created',
        object_type: 's',
        object: Time.now.utc)
    end
  end
end
