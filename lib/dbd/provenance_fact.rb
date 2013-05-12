module Dbd

  ##
  # ProvenanceFact
  #
  # ProvenanceFact is derived from Fact and behaves very similar, except
  # that it's provenance_subject is empty.
  #
  # The provenance_subject of a Fact is used to point it to a set of
  # ProvenanceFacts (a ProvenanceResource). Because the provenance_subject
  # pointer of a ProvenanceFact itself is empty, the usage of
  # provenance_subject is thus not recursive on this level (this allows
  # efficient sequential loading in an underlying databased).
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
    # @param [Subject] subject The subject for this ProvenanceFact
    # @param [#to_s] predicate The predicate for this ProvenanceFact (required)
    # @param [#to_s] object The object for this ProvenanceFact (required)
    def initialize(subject, predicate, object)
      super(nil, subject, predicate, object)
    end

    ##
    # Executes the required update in provenance_subjects.
    #
    # For a ProvenanceFact, there is no provenance_subject, so
    # pointless to mark it in provenance_subjects hash. Also,
    # it is only when a Fact uses a Provenance Resource that the
    # definition of that provenance resource needs to be closed.
    def update_provenance_subjects(h)
      # Do nothing (override the behaviour from super).
    end

    ##
    # Checks if a ProvenanceFact is valid for storing in the graph.
    #
    # In a ProvenanceFact, provenance_subject needs to be nil (this
    # is how the difference is encoded between Facts and ProvenanceFacts).
    # @return [#true?] not nil if valid
    def valid?
      # not calling super as conditions are conflicting
      # other attributes need not be checked, see super_class
      provenance_subject.nil? &&
      subject
    end

    ##
    # Builds duplicate with the subject set.
    #
    # @param [Subject] subject_arg
    # @return [ProvenanceFact] the duplicate fact
    def dup_with_subject(subject_arg)
      self.class.new(
       subject_arg, # from arg
       predicate,
       object)
    end

  end
end
