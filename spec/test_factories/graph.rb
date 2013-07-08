module TestFactories
  module Graph
    def self.factory_for
      ::Dbd::Graph
    end

    def self.new_subject
      ::Dbd::Fact.factory.new_subject
    end

    def self.only_context
      factory_for.new << TestFactories::ContextResource.context_resource
    end

    def self.only_facts(context_subject = new_subject)
      factory_for.new << TestFactories::Resource.facts_resource(context_subject)
    end

    def self.full
      context_resource = TestFactories::ContextResource.context_resource
      resource = TestFactories::Resource.facts_resource(context_resource.subject)
      factory_for.new << context_resource << resource
    end
  end
end
