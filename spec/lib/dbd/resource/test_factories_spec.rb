require 'spec_helper'

module TestFactories
  describe Resource do

    let(:provenance_subject) { TestFactories::ProvenanceResource.provenance_resource.subject }

    describe "TestFactories::Resource" do
      it ".empty works" do
        described_class.facts_resource(provenance_subject)
      end

      context ".facts_resource" do
        it "works with explicit provenance_subject" do
          described_class.facts_resource(provenance_subject)
        end

        it "works without explicit provenance_subject" do
          resource = described_class.facts_resource()
          resource.provenance_subject.should_not be_nil
        end
      end
    end
  end
end
