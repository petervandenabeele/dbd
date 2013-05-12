module Dbd

  ##
  # ProvenanceFact
  #
  # ProvenanceFact is derived from Fact and behaves very similar.
  #
  # The ProvenanceFacts with same subject form a ProvenanceResource and
  # this is used as the target for the provenance_subject of a Fact.
  #
  # The provenance_subject of a ProvenanceFact itself is empty, so the
  # usage of provenance_subject is not recursive on this level (this
  # allows efficient single pass loading in an underlying database).
  #
  # In the serialisation of the fact stream, the presence or absence of a
  # provenance_subject marks the difference between a (base) Fact and a
  # ProvenanceFact.
  #
  # The predicates in a ProvenanceFact would typically come from a defined
  # "provenance ontology". An experimental example of a provenance ontology
  # is built-up on https://data.vandenabeele.com/ontologies/provenance.
  class ProvenanceFact < Fact

    ##
    # Builds a new ProvenanceFact.
    #
    # @param [Hash{Symbol => Object}] options
    # @option options [Fact::Subject] :subject (new_subject) Optional: the subject for the ProvenanceFact
    # @option options [String] :predicate Required: the subject for the ProvenanceFact
    # @option options [String] :object Required: the object for the ProvenanceFact
    def initialize(options)
      validate_provenance_subject(options)
      super
    end

    ##
    # Executes the required update in used_provenance_subjects.
    #
    # For a ProvenanceFact, there is no provenance_subject, so
    # pointless to mark it in used_provenance_subjects hash.
    def update_used_provenance_subjects(h)
      # Do nothing (override the behaviour from super).
    end

    ##
    # Validates the presence or absence of provenance_subject.
    #
    # Here, in the derived ProvenanceFact, it must not be present.
    # @param [#nil?] provenance_subject
    # Return [Boolean]
    def provenance_subject_valid?(provenance_subject)
      provenance_subject.nil?
    end

    ##
    # Builds duplicate with the subject set.
    #
    # @param [Subject] subject_arg
    # @return [ProvenanceFact] the duplicate fact
    def dup_with_subject(subject_arg)
      self.class.new(
       subject: subject_arg, # from arg
       predicate: predicate,
       object: object)
    end

  private

    ##
    # Validate that provenance_subject is not set here.
    def validate_provenance_subject(options)
      raise ProvenanceError if options[:provenance_subject]
    end

  end
end
