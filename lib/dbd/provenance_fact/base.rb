module Dbd
  module ProvenanceFact
    class Base < Fact::Base

      def update_provenance_fact_subject(h)
        # Do nothing. Adding a ProvenanceFact alone does nothing,
        # only refering to it in Fact#provenance_fact_subject does
      end

    end
  end
end
