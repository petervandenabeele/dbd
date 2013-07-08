module Dbd
  ##
  # A ProvenanceResource is derived from a Resource, specifically
  # for a Provenance.
  #
  # The main difference is that it does not have a context_subject.
  class ProvenanceResource < Resource

    ##
    # Build a new ProvenanceResource.
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
    # Add a Context (strictly only a Context).
    #
    # Side effect on subject:
    # * if it has no subject, the subject is set in a duplicate context
    # * if is has the same subject as the resource, added unchanged.
    # * if it has a different subject, a SubjectError is raised.
    def <<(context)
      super
    end

  private

    # Should not be called in ProvenanceResource subclass.
    def context_subject
      raise NoMethodError, "context_subject should not be called in ProvenanceResource."
    end

    def set_context_subject(options)
      raise ArgumentError, "context_subject must not be in the options" if options[:context_subject]
    end

    # Validate that context_subject is not present here.
    # This should never raise as the setter was blocked above.
    def validate_context_subject
      raise ContextError if @context_subject
    end

    ##
    # Assert _only_ Contexts here
    def assert_fact_or_context(fact)
      raise ArgumentError, "Trying to add a non-Context to a ProvenanceResource." unless fact.context?
    end

    ##
    # A noop for ProvenanceResource.
    # @param [Context] context
    def set_fact_context_subject!(context)
      # Do nothing
    end

  end
end
