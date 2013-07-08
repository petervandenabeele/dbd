module TestFactories
  module Resource

    def self.factory_for
      ::Dbd::Resource
    end

    # TODO get this from the Resource class
    def self.element_class
      ::Dbd::Fact
    end

    def self.empty(context_subject)
      subject = element_class.factory.new_subject
      factory_for.new(subject: subject, context_subject: context_subject)
    end

    def self.facts_resource(context_subject = context_subject())
      subject = element_class.factory.new_subject
      factory_for.new(subject: subject, context_subject: context_subject).tap do |resource|
        resource << TestFactories::Fact.data_fact(context_subject, subject)
        resource << TestFactories::Fact.data_fact_EU(context_subject, subject)
      end
    end

  private

    def self.context_subject
      TestFactories::ContextFact.new_subject
    end

  end
end
