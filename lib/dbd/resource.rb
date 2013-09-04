require 'dbd/helpers/ordered_set_collection'

module Dbd
  ##
  # A Resource is a collection of Facts that have the same subject.
  #
  # In the real-world this is a mainly an "instance" about which all
  # facts are giving information (e.g. a conference, a person, a
  # bicycle, ...). More generally this can also be used to describe
  # classes and other concepts in the system.
  #
  # A new (random) subject is generated for a resource. In Dbd,
  # a subject is a random uuid (like a oid), not a meaningful URI
  # as it is in RDF.
  #
  # A context_subject is a required field in the options hash.
  # Practically, first a Context will be created and the
  # subject of that will be used as context_subject for the
  # Resources that are associated with it.
  #
  # During build-up of a Fact, the subject and the context_subject
  # can be nil. These will then be set when the Fact is added
  # (with '<<') to a resource.
  class Resource

    include Helpers::OrderedSetCollection

    attr_reader :subject, :context_subject

    ##
    # @return [Fact::Subject] a new (random) Resource subject
    def self.new_subject
      Fact.factory.new_subject
    end

    ##
    # Build a new resource.
    #
    # By default, a new (random) subject is generated for a resource.
    # Optionally, an explicit subject can be given in the options parameter
    # (this is best created with the new_subject class method for forward
    # compatibility).
    #
    # The context_subject argument is required. This will typically be
    # taken from an earlier created Context.
    #
    # @param [Hash{Symbol => Object}] options
    # @option options [Fact::Subject] :context_subject (required) the subject of the context for this resource
    # @option options [Fact::Subject] :subject (new_subject) Optional: the subject for the resource
    def initialize(options)
      set_subject(options)
      set_context_subject(options)
      super()
    end

    ##
    # Add a Fact (strictly not a ContextFact) or recursive collection of facts
    #
    # Side effects on subject and context_subject:
    # * if it has no subject, the subject is set (this modifies the fact !)
    # * if is has the same subject as the resource, added unchanged.
    # * if it has a different subject, a SubjectError is raised.
    #
    # * if it has no context_subject, the context_subject is set (this modifies the fact !)
    # * if is has the same context_subject as the resource, added unchanged.
    # * if it has a different context_subject, a ContextError is raised.
    #
    # @param [Fact, #each] fact_collection a recursive collection of Facts
    # @return [Resource] self
    def <<(fact_collection)
      fact_collection.each_recursively do |fact|
        prepare_fact!(fact)
        super(fact)
      end
      self
    end

  private

    def set_subject(options)
      @subject = options[:subject] || self.class.new_subject
    end

    def set_context_subject(options)
      @context_subject = options[:context_subject]
      raise ContextError, "context_subject cannot be nil" if @context_subject.nil?
    end

    def set_fact_subject!(fact)
      fact.subject = subject
    end

    def set_fact_context_subject!(fact)
      fact.context_subject = context_subject
    end

    def prepare_fact!(fact)
      assert_fact_or_context_fact(fact)
      set_fact_subject!(fact)
      set_fact_context_subject!(fact)
    end

    # Assert _no_ Contexts here
    def assert_fact_or_context_fact(fact)
      raise ArgumentError, "Trying to add a ContextFact to a Resource." if fact.context_fact?
    end

  end
end
