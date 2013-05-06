require 'spec_helper'

module Dbd
  module ProvenanceFact
    describe Base do

      let(:provenance_subject) do
        UUIDTools::UUID.random_create
      end

      let(:provenance_fact_1) do
        described_class.new(
          nil,
          provenance_subject,
          "https://data.vandenabeele.com/ontologies/provenance#context",
          "public")
      end

      let(:provenance_fact_2) do
        described_class.new(
          nil,
          provenance_subject,
          "https://data.vandenabeele.com/ontologies/provenance#created_by",
          "peter_v")
      end

      let(:provenance_fact_full_option) do
        Factories::ProvenanceFact.me
      end

      describe "#new" do
        it "has a unique id (UUID)" do
          provenance_fact_1.id.should be_a(UUIDTools::UUID)
        end

        it "two provenance_facts have different id" do
          provenance_fact_1.id.should_not == provenance_fact_2.id
        end

        it "has nil provenance_id" do
          provenance_fact_1.provenance_fact_id.should be_nil
        end

        it "has correct subject" do
          provenance_fact_1.subject.should == provenance_subject
        end

        it "has correct property" do
          provenance_fact_1.property.should == "https://data.vandenabeele.com/ontologies/provenance#context"
        end

        it "has correct object" do
          provenance_fact_1.object.should == "public"
        end
      end

      describe "Factories do not fail" do
        it "Factories::ProvenanceFact.context is OK" do
          Factories::ProvenanceFact.context.should_not be_nil
        end

        it "Factories::ProvenanceFact.created_by" do
          Factories::ProvenanceFact.created_by.should_not be_nil
        end

        it "Factories::ProvenanceFact.original_source is OK" do
          Factories::ProvenanceFact.original_source.should_not be_nil
        end
      end
    end
  end
end
