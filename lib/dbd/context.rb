module Dbd

  ##
  # Context
  #
  # Context is derived from Fact and behaves very similar.
  #
  # The Contexts with same subject form a ContextResource and
  # this is used as the target for the context_subject of a Fact.
  #
  # The context_subject of a Context itself is empty, so the
  # usage of context_subject is not recursive on this level (this
  # allows efficient single pass loading in an underlying database).
  #
  # In the serialisation of a fact stream, the presence or absence of a
  # context_subject marks the difference between a Fact and a Context.
  #
  # The predicates in a Context would typically come from a defined
  # context and provenance ontology. Experimental examples of
  # ontologies are built in the dbd_onto project.
  class Context < Fact

    ##
    # Builds a new Context.
    #
    # @param [Hash{Symbol => Object}] options
    # @option options [Fact::Subject] :subject (new_subject) Optional: the subject for the Context
    # @option options [String] :predicate Required: the subject for the Context
    # @option options [String] :object Required: the object for the Context
    def initialize(options)
      validate_context_subject(options)
      super
    end

    ##
    # Executes the required update in used_context_subjects.
    #
    # For a Context, there is no context_subject, so
    # pointless to mark it in used_context_subjects hash.
    def update_used_context_subjects(h)
      # Do nothing (override the behaviour from super).
    end

    ##
    # Validates the presence or absence of context_subject.
    #
    # Here, in the derived Context, it must not be present.
    # @param [#nil?] context_subject
    # Return [nil, String] nil if valid, an error message if not
    def context_subject_error(context_subject)
      "Context subject should not be present in Context" if context_subject
    end

    ##
    # Confirms this is a Context
    #
    # Needed for validations that depend on different behavior for
    # a context (mainly, no context_subject).
    def context?
      true
    end

  private

    ##
    # Validate that context_subject is not set here.
    def validate_context_subject(options)
      raise ContextError if options[:context_subject]
    end

    def context_subject_short
      "[ cont ]"
    end

  end
end
