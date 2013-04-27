module Factories
  module Fact

    def self.fact_1
      ::Dbd::Fact::Base.new(
        Factories::FactOrigin.me.id,
        UUIDTools::UUID.random_create)
    end

    def self.fact_2
      ::Dbd::Fact::Base.new(
        Factories::FactOrigin.me.id,
        UUIDTools::UUID.random_create)
    end

  end
end
