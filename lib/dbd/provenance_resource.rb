module Dbd
  ##
  # A ProvenanceResource is derived from a Resource, specifically
  # for a Provenance (does not have and does need a provenance_fact_subject)
  #
  # The subject is required from the creation of a new resource.
  class ProvenanceResource < Resource

    ##
    # Build a new ProvenanceResource.
    #
    # The subject argument is required (because later
    # additions of elements take over this subject).
    #
    # @param [Subject] subject the subject for the resource
    def initialize(subject)
      super(subject, nil)
    end

    ##
    # Getter for provenance_subject.
    #
    # Should not be called in ProvenanceResource subclass.
    def provenance_subject
      raise RuntimeError, "provenance_subject should not be called here."
    end

  protected

    def validate_provenance_subject
      # do nothing. Do not force validation for ProvenanceResource
    end

  end
end
