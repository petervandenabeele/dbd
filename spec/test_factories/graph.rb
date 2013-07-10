module TestFactories
  module Graph
    def self.factory_for
      ::Dbd::Graph
    end

    def self.new_subject
      ::Dbd::Fact.factory.new_subject
    end

    def self.only_context
      factory_for.new << TestFactories::Context.context
    end

    def self.only_facts(context_subject = new_subject)
      factory_for.new << TestFactories::Resource.facts_resource(context_subject)
    end

    def self.full
      context = TestFactories::Context.context
      resource = TestFactories::Resource.facts_resource(context.subject)
      factory_for.new << context << resource
    end
  end
end
