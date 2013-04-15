module Factories
  module Fact

    def self.fact_origin_id
      #NOTE will be a different id on each invocation
      Factories::FactOrigin.me.id
    end

    def self.subject_id
      UUIDTools::UUID.random_create
    end

    def self.fact_1
      ::Dbd::Fact::Fact.new(fact_origin_id, subject_id)
    end

    def self.fact_2
      ::Dbd::Fact::Fact.new(fact_origin_id, subject_id)
    end

  end
end
