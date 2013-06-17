module Factories
  module Fact

    def self.factory_for
      ::Dbd::Fact
    end

    def self.new_subject
      factory_for.new_subject
    end

    def self.fact_1(provenance_subject = nil)
      factory_for.new(
        provenance_subject: provenance_subject,
        predicate: "http://example.org/test/name",
        object: "Gandhi")
    end

    def self.fact_with_forced_id(forced_id)
      factory_for.new(
        id: forced_id,
        predicate: "http://example.org/test/name",
        object: "Gandhi")
    end

    def self.fact_with_time_stamp(time_stamp)
      factory_for.new(
        time_stamp: time_stamp,
        predicate: "http://example.org/test/name",
        object: "Gandhi")
    end

    def self.fact_2_with_subject(provenance_subject = nil)
      factory_for.new(
        provenance_subject: provenance_subject,
        subject: new_subject,
        predicate: "http://example.org/test/name",
        object: "Mandela")
    end

    def self.fact_3_with_subject(provenance_subject = nil)
      factory_for.new(
        provenance_subject: provenance_subject,
        subject: new_subject,
        predicate: "http://example.org/test/name",
        object: "King")
    end

    def self.data_fact(provenance_subject = nil, subject = nil)
      factory_for.new(
        provenance_subject: provenance_subject,
        subject: subject,
        predicate: "http://example.org/test/name",
        object: "Aung San Suu Kyi")
    end

    def self.data_fact_EU(provenance_subject = nil, subject = nil)
      factory_for.new(
        provenance_subject: provenance_subject,
        subject: subject,
        predicate: "http://example.org/test/name",
        object: "European Union")
    end

    def self.fact_with_newline(provenance_subject = nil, subject = nil)
      factory_for.new(
        provenance_subject: provenance_subject,
        subject: subject,
        predicate: "http://example.org/test/comment",
        object: "A long story\nreally.")
    end

    def self.full_fact
      fixed_id = Factories::Fact::ID.fixed_id
      fact_with_forced_id(fixed_id).tap do |fact|
        fact.time_stamp = Factories::TimeStamp.fixed_time_stamp
        fact.subject = Factories::Fact::Subject.fixed_subject
        fact.provenance_subject = Factories::Fact::Subject.fixed_provenance_subject
      end
    end

    module Collection

      def self.factory_for_instance
        o = Object.new
        o.extend(::Dbd::Fact::Collection)
        o.send(:initialize)
        o
      end

      def self.fact_2_3(provenance_subject)
        factory_for_instance.tap do |fact_collection|
          fact_collection << Fact.fact_2_with_subject(provenance_subject)
          fact_collection << Fact.fact_3_with_subject(provenance_subject)
        end
      end

      def self.provenance_facts(subject)
        factory_for_instance.tap do |provenance_facts|
          provenance_facts << ProvenanceFact.context(subject)
          provenance_facts << ProvenanceFact.created_by(subject)
          provenance_facts << ProvenanceFact.original_source(subject)
        end
      end
    end
  end
end
