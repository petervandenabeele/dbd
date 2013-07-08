module TestFactories
  module ContextResource

    def self.factory_for
      ::Dbd::ContextResource
    end

    def self.context_resource
      factory_for.new.tap do |context_resource|
        context_resource << TestFactories::ContextFact.visibility
        context_resource << TestFactories::ContextFact.created_by
      end
    end

  end
end
