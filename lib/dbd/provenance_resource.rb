module Dbd
  ##
  # A ProvenanceResource is derived from a Resource, specifically
  # for a Provenance.
  #
  # The main difference is that it does not have a provenance_subject.
  class ProvenanceResource < Resource

    ##
    # Build a new ProvenanceResource.
    #
    # The subject can be either given as an argument or a new (random)
    # subject is automatically set (see Resource for details).
    #
    # A provenance_subject may not be given here.
    # @option options [Fact::Subject] :subject (new_subject) Optional: the subject for the resource
    def initialize(options = {})
      super
    end

    ##
    # Add a ProvenanceFact (strictly only a ProvenanceFact).
    #
    # Side effect on subject:
    # * if it has no subject, the subject is set in a duplicate provenance_fact
    # * if is has the same subject as the resource, added unchanged.
    # * if it has a different subject, a SubjectError is raised.
    def <<(provenance_fact)
      super
    end

  private

    # Should not be called in ProvenanceResource subclass.
    def provenance_subject
      raise NoMethodError, "provenance_subject should not be called in ProvenanceResource."
    end

    def set_provenance_subject(options)
      raise ArgumentError, "provenance_subject must not be in the options" if options[:provenance_subject]
    end

    # Validate that provenance_subject is not present here.
    # This should never raise as the setter was blocked above.
    def validate_provenance_subject
      raise ProvenanceError if @provenance_subject
    end

    ##
    # Assert _only_ ProvenanceFacts here
    def assert_fact_provenance_fact(fact)
      raise ArgumentError, "Trying to add a non-ProvenanceFact to a ProvenanceResource." unless fact.provenance_fact?
    end

    ##
    # A noop for ProvenanceResource.
    # @param [ProvenanceFact] provenance_fact
    def set_fact_provenance!(provenance_fact)
      # Do nothing
    end

  end
end
