require 'spec_helper'

module Dbd
  describe Resource do

    let(:provenance_subject) { Factories::ProvenanceResource.provenance_resource.subject }

    describe "Factories::Resource" do
      it ".empty works" do
        Factories::Resource.facts_resource(provenance_subject)
      end

      it ".facts_resource works" do
        Factories::Resource.facts_resource(provenance_subject)
      end
    end
  end
end
