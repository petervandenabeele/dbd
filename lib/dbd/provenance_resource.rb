module Dbd
  ##
  # A ProvenanceResource is derived from a Resource, specifically
  # for a Provenance (does not have and does need a provenance_subject)
  class ProvenanceResource < Resource

    class InvalidProvenanceError < StandardError ; end

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
    # Add an element.
    #
    # * if it has no subject, the subject is set in a duplicate element
    # * if is has the same subject as the resource, added unchanged.
    # * if it has a different subject, a InvalidSubjectError is raised.
    def <<(element)
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
    # @override
    def validate_provenance_subject
      raise InvalidProvenanceError if @provenance_subject
    end

    ##
    # Check provenance_subject, which should be nil here
    # @override
    # @param [ProvenanceFact] provenance_fact
    # @return [ProvenanceFact] with validated nil on provenance_subject
    def check_or_set_provenance(provenance_fact)
      raise InvalidProvenanceError if provenance_fact.provenance_subject
      provenance_fact
    end

  end
end
