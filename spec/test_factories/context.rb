module TestFactories
  module Context

    def self.factory_for
      ::Dbd::Context
    end

    def self.context
      factory_for.new.tap do |context|
        context << TestFactories::ContextFact.visibility
        context << TestFactories::ContextFact.created_by
      end
    end

  end
end
