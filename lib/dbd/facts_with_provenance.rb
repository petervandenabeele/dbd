require 'dbd/facts_with_provenance/collection'

module Dbd

  ##
  # FactsWithProvenance is a set of facts for 1 or more subjects
  # that are all associated with one set of provenance_facts
  #
  # The steps are:
  # * make a set of provenance_facts (FactsBySubject.new) and
  #   add provenance_facts to that
  # * make 1 or more sets of facts (FactsBySubject.new) and
  #   add facts to that, grouped per subject
  # * make FactsWithProvenance.new(provenance_facts) and
  #   add the sets of facts (FactsBySubject) to that
  # * call facts_with_provenance.generate_subjects to
  #   generate the missing subjects and interlink
  # * call the Graph#store method with facts_with_provenance
  class FactsWithProvenance

    attr_reader :facts_by_subject_collection

    ##
    # Initialize the FactsWithProvenance with a set of ProvenanceFacts.
    #
    # @param [FactsBySubject] provenance_facts the set of provenance facts for these facts
    def initialize(provenance_facts)
      @provenance_facts = provenance_facts
      @facts_by_subject_collection = Collection.new
    end

  end
end
