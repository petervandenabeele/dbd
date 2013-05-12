module Dbd
  ##
  # A ProvenanceResource is derived from a Resource, specifically
  # for a Provenance (does not have and does need a provenance_subject)
  #
  # The subject is required for the creation of a new resource.
  class ProvenanceResource < Resource

    class InvalidProvenanceError < StandardError ; end

    ##
    # Build a new ProvenanceResource.
    #
    # The subject argument is required (because later
    # additions of elements take over this subject).
    #
    # @param [Subject] subject the subject for the ProvenanceResource
    def initialize(subject)
      super(subject, nil)
    end

  private

    ##
    # Should not be called in ProvenanceResource subclass.
    def provenance_subject
      raise RuntimeError, "provenance_subject should not be called in ProvenanceResource."
    end

    ##
    # Do nothing. Do not force provenance_subject validation here.
    # @override
    def validate_provenance_subject
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
