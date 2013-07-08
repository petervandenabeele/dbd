module Dbd

  ##
  # ContextFact
  #
  # ContextFact is derived from Fact and behaves very similar.
  #
  # The ContextFacts with same subject form a ContextResource and
  # this is used as the target for the context_subject of a Fact.
  #
  # The context_subject of a ContextFact itself is empty, so the
  # usage of context_subject is not recursive on this level (this
  # allows efficient single pass loading in an underlying database).
  #
  # In the serialisation of a fact stream, the presence or absence of a
  # context_subject marks the difference between a Fact and a ContextFact.
  #
  # The predicates of the ContextFacts in a ContextResource would
  # typically come from a defined context ontology (including provenance).
  # Experimental examples of ontologies are built in the dbd_onto project.
  class ContextFact < Fact

    ##
    # Builds a new ContextFact.
    #
    # @param [Hash{Symbol => Object}] options
    # @option options [Fact::Subject] :subject (new_subject) Optional: the subject for the ContextFact
    # @option options [String] :predicate Required: the subject for the ContextFact
    # @option options [String] :object Required: the object for the ContextFact
    def initialize(options)
      validate_context_subject(options)
      super
    end

    ##
    # Executes the required update in used_context_subjects.
    #
    # For a ContextFact, there is no context_subject, so
    # pointless to mark it in used_context_subjects hash.
    def update_used_context_subjects(h)
      # Do nothing (override the behaviour from super).
    end

    ##
    # Validates the presence or absence of context_subject.
    #
    # Here, in the derived ContextFact, it must not be present.
    # @param [#nil?] context_subject
    # Return [nil, String] nil if valid, an error message if not
    def context_subject_error(context_subject)
      "ContextFact subject should not be present in ContextFact" if context_subject
    end

    ##
    # Confirms this is a ContextFact
    #
    # Needed for validations that depend on different behavior for
    # a context_fact (mainly, no context_subject).
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
