require 'spec_helper'

module Dbd
    describe ProvenanceFact do

      let(:subject) { described_class.new_subject }
      let(:id_class) { described_class.new_id.class }

      let(:provenance_fact_1) do
        Factories::ProvenanceFact.context(subject)
      end

      let(:provenance_fact_2) do
        Factories::ProvenanceFact.created_by(subject)
      end

      describe "#new" do
        it "has a unique id (new_id.class)" do
          provenance_fact_1.id.should be_a(id_class)
        end

        it "two provenance_facts have different id" do
          provenance_fact_1.id.should_not == provenance_fact_2.id
        end

        it "has nil provenance_fact_subject" do
          provenance_fact_1.provenance_fact_subject.should be_nil
        end

        it "has correct subject" do
          provenance_fact_1.subject.should == subject
        end

        it "has correct predicate" do
          provenance_fact_1.predicate.should == "https://data.vandenabeele.com/ontologies/provenance#context"
        end

        it "has correct object" do
          provenance_fact_1.object.should == "public"
        end
      end

      describe "valid?" do
        it "the factory isi valid?" do
          provenance_fact_1.should be_valid
        end

        it "with ! provenance_fact_subject is not valid?" do
          provenance_fact_1.stub(:provenance_fact_subject).and_return(subject)
          provenance_fact_1.should_not be_valid
        end

        it "without subject is not valid?" do
          provenance_fact_1.stub(:subject).and_return(nil)
          provenance_fact_1.should_not be_valid
        end
      end

      describe "update_provenance_fact_subjects" do
        it "does nothing for a provenance_fact" do
          h = {}
          provenance_fact_1.update_provenance_fact_subjects(h)
          h.should be_empty
        end
      end

      describe "Factories do not fail" do
        it "Factories::ProvenanceFact.context is OK" do
          Factories::ProvenanceFact.context.should_not be_nil
        end

        it "Factories::ProvenanceFact.created_by is OK" do
          Factories::ProvenanceFact.created_by.should_not be_nil
        end

        it "Factories::ProvenanceFact.original_source is OK" do
          Factories::ProvenanceFact.original_source.should_not be_nil
        end
      end
    end
end
