# encoding=utf-8
module TestFactories
  module Context
    def self.factory_for
      ::Dbd::Context
    end

    def self.new_subject
      factory_for.factory.new_subject
    end

    def self.visibility(subject = nil)
      factory_for.new(
        subject: subject,
        predicate: 'context:visibility',
        object: 'public')
    end

    def self.created_by(subject = nil)
      factory_for.new(
        subject: subject,
        predicate: 'dcterms:creator',
        object: 'peter_v')
    end

    def self.original_source(subject = nil)
      factory_for.new(
        subject: subject,
        predicate: 'prov:source',
        object: "this has a comma , a newline \n and a double quote \"")
    end

    def self.created(subject = nil)
      factory_for.new(
        subject: subject,
        predicate: 'dcterms:created',
        object: Time.now.utc)
    end
  end
end
