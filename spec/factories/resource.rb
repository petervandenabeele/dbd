module Factories
  module Resource

    def self.provenance_resource
      ::Dbd::Resource.new.tap do |resource|
        resource << Factories::ProvenanceFact.context
        resource << Factories::ProvenanceFact.created_by
      end
    end

    def self.resource_1
      ::Dbd::Resource.new.tap do |resource|
        resource << Factories::Fact.fact_1
      end
    end

    def self.resource_2_3
      ::Dbd::Resource.new.tap do |resource|
        resource << Factories::Fact.fact_2_with_subject
        resource << Factories::Fact.fact_3_with_subject
      end
    end

  end
end
