module Dbd
  class ProvenanceFact < Fact

    def update_provenance_fact_subjects(h)
      # Do nothing. Adding a ProvenanceFact alone does nothing,
      # only refering to it in a Fact#provenance_fact_subject does
    end

    def valid?
      # not calling super as conditions are conflicting
      # other attributes need not be checked, see super_class
      provenance_fact_subject.nil? &&
      subject
    end

  end
end
