module Factories
  module Resource

    def self.factory_for
      ::Dbd::Resource
    end

    def self.facts_resource
      factory_for.new(Fact.new_subject, ProvenanceFact.new_subject).tap do |resource|
        resource << Factories::Fact.fact_1
        resource << Factories::Fact.data_fact
      end
    end

  end
end
