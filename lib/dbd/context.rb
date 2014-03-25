module Dbd
  ##
  # A Context is derived from a Resource, and is the
  # set of all ContextFacts that share the same subject.
  #
  # It is pointed to by a context_subject of a Fact and has
  # no context_subject itself (the context_subject
  # relationship from Fact to ContextFact is not recursive).
  class Context < Resource

    ##
    # Build a new Context.
    #
    # The subject can be either given as an argument or a new (random)
    # subject is automatically set (see Resource for details).
    #
    # A context_subject may not be given here.
    # @option options [Fact::Subject] :subject (new_subject) Optional: the subject for the resource
    def initialize(options = {})
      super
    end

    ##
    # Add a ContextFact (strictly only a ContextFact) or recursive collection of ContextFacts
    #
    # Side effect on the context_fact argument:
    # * if it has no subject, the subject is set in the context_fact
    # * if is has the same subject as the resource, added unchanged.
    # * if it has a different subject, a SubjectError is raised.
    #
    # NOTE: this implementation is really only here for the documentation
    #
    # @param [ContextFact, #each] context_fact_collection a recursive collection of ContextFacts
    # @return [Context] self
    def <<(context_fact_collection)
      super
    end

    # Should not be called in Context subclass.
    private :context_subject

    private

    def set_context_subject(options)
      raise ArgumentError, "context_subject must not be in the options" if options[:context_subject]
    end

    ##
    # Assert _only_ Contexts here
    def assert_fact_or_context_fact(context_fact)
      raise ArgumentError, "Trying to add a non-ContextFact to a Context." unless context_fact.context_fact?
    end

    ##
    # A noop for Context.
    # @param [ContextFact] context_fact
    def set_fact_context_subject!(context_fact)
      # Do nothing
    end

  end
end
