require 'spec_helper'

module Dbd
  describe ProvenanceFact do

    let(:subject) { described_class.new_subject }

    let(:provenance_fact_1) do
      Factories::ProvenanceFact.context(subject)
    end

    let(:provenance_fact_created) do
      Factories::ProvenanceFact.created(subject)
    end

    describe "short" do
      it "for a provenance fact shows [ prov ], subj, predicate, object" do
        provenance_fact_1.short.should match(/^\[ prov \] : [0-9a-f]{8} : https:\/\/data\.vandenabeel : public$/)
      end

      it "for a provenance fact with non string object also works" do
        provenance_fact_created.short.should match(/^\[ prov \] : [0-9a-f]{8} : dcterms:created          : \d{4}/)
      end
    end

    describe "errors" do
      it "the factory has no errors" do
        provenance_fact_1.errors.should be_empty
      end

      describe "with a provenance_subject" do

        before(:each) do
          provenance_fact_1.stub(:provenance_subject).and_return(subject)
        end

        it "errors returns an array with 1 error message" do
          provenance_fact_1.errors.single.should match(/Provenance subject should not be present in Provenance Fact/)
        end
      end

      describe "without subject" do

        before(:each) do
          provenance_fact_1.stub(:subject).and_return(nil)
        end

        it "errors returns an array with an error message" do
          provenance_fact_1.errors.single.should match(/Subject is missing/)
        end
      end
    end

    describe "update_used_provenance_subjects" do
      it "does nothing for a provenance_fact" do
        h = {}
        provenance_fact_1.update_used_provenance_subjects(h)
        h.should be_empty
      end
    end
  end
end
