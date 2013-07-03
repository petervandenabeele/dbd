require 'spec_helper'

module TestFactories
  describe Resource do

    let(:provenance_subject) { TestFactories::ProvenanceResource.provenance_resource.subject }

    describe "TestFactories::Resource" do
      it ".empty works" do
        described_class.facts_resource(provenance_subject)
      end

      it ".facts_resource works" do
        described_class.facts_resource(provenance_subject)
      end
    end
  end
end
