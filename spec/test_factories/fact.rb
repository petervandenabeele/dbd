# encoding=utf-8
module TestFactories
  module Fact
    def self.factory_for
      ::Dbd::Fact
    end

    def self.new_subject
      factory_for.factory.new_subject
    end

    def self.string_values
      ['825e44d5-af33-4858-8047-549bd813daa8',
       '2013-06-17 21:55:09.967653013 UTC',
       '40fab407-9b04-4a51-9a52-d978abfcbb1f',
       '2e9fbc87-2e94-47e9-a8fd-121cc4bc3e8f',
       'http://example.org/test/name',
       'Gandhi']
    end

    def self.fact_1(context_subject = nil)
      factory_for.new(
        context_subject: context_subject,
        predicate: 'http://example.org/test/name',
        object: 'Gandhi')
    end

    def self.fact_with_forced_id(forced_id)
      factory_for.new(
        id: forced_id,
        predicate: 'http://example.org/test/name',
        object: 'Gandhi')
    end

    def self.fact_with_special_chars(context_subject = nil, subject = nil)
      factory_for.new(
        context_subject: context_subject,
        subject: subject,
        predicate: 'http://example.org/test/comment',
        object: "A long story with a newline\nreally with a comma, a double quote \" and a non-ASCII char éà Über.")
    end

    def self.fact_with_time_stamp(time_stamp)
      factory_for.new(
        time_stamp: time_stamp,
        predicate: 'http://example.org/test/name',
        object: 'Gandhi')
    end

    def self.fact_2_with_subject(context_subject = nil)
      factory_for.new(
        context_subject: context_subject,
        subject: new_subject,
        predicate: 'http://example.org/test/name',
        object: 'Mandela')
    end

    def self.fact_3_with_subject(context_subject = nil)
      factory_for.new(
        context_subject: context_subject,
        subject: new_subject,
        predicate: 'http://example.org/test/name',
        object: 'King')
    end

    def self.data_fact(context_subject = nil, subject = nil)
      factory_for.new(
        context_subject: context_subject,
        subject: subject,
        predicate: 'http://example.org/test/name',
        object: 'Aung San Suu Kyi')
    end

    def self.data_fact_EU(context_subject = nil, subject = nil)
      factory_for.new(
        context_subject: context_subject,
        subject: subject,
        predicate: 'http://example.org/test/name',
        object: 'European Union')
    end

    def self.fact_with_newline(context_subject = nil, subject = nil)
      factory_for.new(
        context_subject: context_subject,
        subject: subject,
        predicate: 'http://example.org/test/comment',
        object: "A long story\nreally.")
    end

    def self.full_fact
      fixed_id = TestFactories::Fact::ID.fixed_id
      fact_with_forced_id(fixed_id).tap do |fact|
        fact.time_stamp = TestFactories::TimeStamp.fixed_time_stamp
        fact.subject = TestFactories::Fact::Subject.fixed_subject
        fact.context_subject = TestFactories::Fact::Subject.fixed_context_subject
      end
    end

    module Collection
      def self.factory_for_instance
        o = Object.new
        o.extend(::Dbd::Fact::Collection)
        o.send(:initialize)
        o
      end

      def self.fact_2_3(context_subject)
        factory_for_instance.tap do |fact_collection|
          fact_collection << Fact.fact_2_with_subject(context_subject)
          fact_collection << Fact.fact_3_with_subject(context_subject)
        end
      end

      def self.context_facts(subject)
        factory_for_instance.tap do |context_facts|
          context_facts << ContextFact.visibility(subject)
          context_facts << ContextFact.created_by(subject)
          context_facts << ContextFact.original_source(subject)
        end
      end
    end
  end
end
