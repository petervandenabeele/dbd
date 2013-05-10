require 'spec_helper'

module Dbd
  describe FactsWithProvenance do

    let(:provenance_facts) do
      FactsBySubject.new.tap do |fbs|
        fbs << Factories::ProvenanceFact.context
        fbs << Factories::ProvenanceFact.created_by
      end
    end

    let(:facts_1) do
      FactsBySubject.new.tap do |fbs|
        fbs << Factories::Fact.fact_1
        fbs << Factories::Fact.fact_2_with_subject
      end
    end

    let(:facts_2) do
      FactsBySubject.new.tap do |fbs|
        fbs << Factories::Fact.fact_3_with_subject
      end
    end

    let(:facts_with_provenance) do
      described_class.new(provenance_facts)
    end

    describe ".new" do
      describe "with a provenance_facts argument" do
        it "does not raise exception" do
          described_class.new(provenance_facts)
        end
      end
    end

    describe "facts_by_subject_collection" do
      it "does not raise exception" do
        facts_with_provenance.facts_by_subject_collection
      end

      it "a facts_by_subject set can be added" do
        facts_with_provenance.facts_by_subject_collection << facts_1
      end

      it "two facts_by_subject set can be added" do
        facts_with_provenance.facts_by_subject_collection << facts_1
        facts_with_provenance.facts_by_subject_collection << facts_2
      end
    end

    it "Factories work" do
      full_factory = Factories::FactsWithProvenance.full_factory
      full_factory.facts_by_subject_collection.count.should == 2
    end
  end
end
