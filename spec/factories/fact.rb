module Factories
  module Fact

    def self.factory_for
      ::Dbd::Fact
    end

    def self.new_subject
      factory_for.new_subject
    end

    def self.fact_1(provenance_fact_subject = nil)
      factory_for.new(
        provenance_fact_subject,
        nil,
        "http://example.org/test/name",
        "Gandhi")
    end

    def self.fact_2_with_subject(provenance_fact_subject = nil)
      factory_for.new(
        provenance_fact_subject,
        new_subject,
        "http://example.org/test/name",
        "Mandela")
    end

    def self.fact_3_with_subject(provenance_fact_subject = nil)
      factory_for.new(
        provenance_fact_subject,
        new_subject,
        "http://example.org/test/name",
        "King")
    end

    def self.data_fact(provenance_fact_subject = nil, subject = nil)
      factory_for.new(
        provenance_fact_subject,
        subject,
        "http://example.org/test/name",
        "Aung San Suu Kyi")
    end

    #TODO move this to resource factory
    module Collection

      def self.factory_for
        ::Dbd::Fact::Collection
      end

      def self.fact_2_3(provenance_fact_subject)
        factory_for.new.tap do |fact_collection|
          fact_collection << Fact.fact_2_with_subject(provenance_fact_subject)
          fact_collection << Fact.fact_3_with_subject(provenance_fact_subject)
        end
      end

      def self.provenance_facts(subject)
        factory_for.new.tap do |provenance_facts|
          provenance_facts << ProvenanceFact.context(subject)
          provenance_facts << ProvenanceFact.created_by(subject)
          provenance_facts << ProvenanceFact.original_source(subject)
        end
      end
    end
  end
end
