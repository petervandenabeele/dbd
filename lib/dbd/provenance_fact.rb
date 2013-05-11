module Dbd

  ##
  # ProvenanceFact
  #
  # Each basic Fact has a set of ProvenanceFacts (logically a Provenance Resource).
  # A ProvenanceFact itself has a nil provenance_fact_subject (ProvenanceFact is
  # not recursive on this level).
  #
  # The predicates in a ProvenanceFact would typically come from a defined
  # "provenance ontology". An experimental example of a provenance ontology
  # is built-up on https://data.vandenabeele.com/ontologies/provenance.
  class ProvenanceFact < Fact

    ##
    # Executes the required update in provenance_fact_subjects.
    #
    # For a ProvenanceFact, there is no provenance_fact_subject, so
    # pointless to mark it in provenance_fact_subjects hash. Also,
    # it is only when a Fact uses a Provenance Resource that the
    # definition of that provenance resource needs to be closed.
    def update_provenance_fact_subjects(h)
      # Do nothing (override the behaviour from super).
    end

    ##
    # Checks if a ProvenanceFact is valid for storing in the graph.
    #
    # In a ProvenanceFact, provenance_fact_subject needs to be nil (this
    # is how the difference is encoded between Facts and ProvenanceFacts).
    # @return [#true?] not nil if valid
    def valid?
      # not calling super as conditions are conflicting
      # other attributes need not be checked, see super_class
      provenance_fact_subject.nil? &&
      subject
    end

  end
end
