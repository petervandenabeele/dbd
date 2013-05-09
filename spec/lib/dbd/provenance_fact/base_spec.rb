require 'spec_helper'

module Dbd
  module ProvenanceFact
    describe Base do

      let(:provenance_fact_subject) { Helpers::UUID.new }

      let(:provenance_fact_1) do
        described_class.new(
          nil, # no recursion on provenance_fact
          provenance_fact_subject,
          "https://data.vandenabeele.com/ontologies/provenance#context",
          "public")
      end

      let(:provenance_fact_2) do
        described_class.new(
          nil, # no recursion on provenance_fact
          provenance_fact_subject,
          "https://data.vandenabeele.com/ontologies/provenance#created_by",
          "peter_v")
      end

      describe "#new" do
        it "has a unique id (UUID)" do
          provenance_fact_1.id.should be_a(provenance_fact_subject.class)
        end

        it "two provenance_facts have different id" do
          provenance_fact_1.id.should_not == provenance_fact_2.id
        end

        it "has nil provenance_fact_subject" do
          provenance_fact_1.provenance_fact_subject.should be_nil
        end

        it "has correct subject" do
          provenance_fact_1.subject.should == provenance_fact_subject
        end

        it "has correct predicate" do
          provenance_fact_1.predicate.should == "https://data.vandenabeele.com/ontologies/provenance#context"
        end

        it "has correct object" do
          provenance_fact_1.object.should == "public"
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
end
