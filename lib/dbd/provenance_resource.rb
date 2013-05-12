module Dbd
  ##
  # A ProvenanceResource is derived from a Resource, specifically
  # for a Provenance (does not have and does need a provenance_subject)
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
    # Add a ProvenanceFact.
    #
    # * if it has no subject, the subject is set in a duplicate provenance_fact
    # * if is has the same subject as the resource, added unchanged.
    # * if it has a different subject, a SubjectError is raised.
    def <<(provenance_fact)
      # TODO: check the type of the provenance_fact (ProvenanceFact)
      super
    end

  private

    ##
    # Should not be called in ProvenanceResource subclass.
    def provenance_subject
      raise RuntimeError, "provenance_subject should not be called in ProvenanceResource."
    end

    ##
    # Validate that provenance_subject is not set here.
    def validate_provenance_subject
      raise ProvenanceError if @provenance_subject
    end

    ##
    # Check provenance_subject, which should be nil here
    # @param [ProvenanceFact] provenance_fact
    # @return [ProvenanceFact] with validated nil on provenance_subject
    def check_or_set_provenance(provenance_fact)
      raise ProvenanceError if provenance_fact.provenance_subject
      provenance_fact
    end

  end
end
