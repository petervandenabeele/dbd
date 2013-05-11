require 'spec_helper'

module Dbd
  describe ResourcesWithProvenance do

    let(:provenance_resource) do
      Resource.new.tap do |resource|
        resource << Factories::ProvenanceFact.context
        resource << Factories::ProvenanceFact.created_by
      end
    end

    let(:resource_1) do
      Resource.new.tap do |resource|
        resource << Factories::Fact.fact_1
      end
    end

    let(:resource_2_3_with_subject) do
      Resource.new.tap do |resource|
        resource << Factories::Fact.fact_2_with_subject
        resource << Factories::Fact.fact_3_with_subject
      end
    end

    let(:resources_with_provenance) do
      described_class.new(provenance_resource)
    end

    describe ".new(provenance_facts)" do
      describe "with a provenance_facts argument" do
        it "does not raise exception" do
          resources_with_provenance
        end
      end
    end

    describe "#resource_collection" do
      it "does not raise exception" do
        resources_with_provenance.resource_collection
      end

      it "a resource set can be added" do
        resources_with_provenance.resource_collection << resource_1
      end

      it "two resources can be added" do
        resources_with_provenance.resource_collection << resource_1
        resources_with_provenance.resource_collection << resource_2_3_with_subject
      end
    end

    it "Factories work" do
      full_factory = Factories::ResourcesWithProvenance.full_factory
      full_factory.resource_collection.count.should == 2
    end
  end
end
