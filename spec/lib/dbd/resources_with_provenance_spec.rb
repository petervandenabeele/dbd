require 'spec_helper'

module Dbd
  describe ResourcesWithProvenance do

    let(:provenance_resource) { Factories::ProvenanceResource.provenance_resource }
    let(:provenance_subject) { provenance_resource.subject }
    let(:facts_resource) { Factories::Resource.facts_resource(provenance_subject) }
    let(:facts_resource_other_provenance) { Factories::Resource.facts_resource(Factories::ProvenanceFact.new_subject) }

    let(:resources_with_provenance) do
      described_class.new(provenance_resource)
    end

    let(:resources_with_provenance_and_resources) do
      resources_with_provenance.tap do |rwp|
        rwp << facts_resource
      end
    end

    describe "adding a resource with <<" do
      it "succeeds if the resource has the correct provenance_subject" do
        resources_with_provenance << facts_resource
      end

      it "raises InvalidProvenanceError if the resource has different provenance_subject" do
        lambda { resources_with_provenance << facts_resource_other_provenance } .
          should raise_error described_class::InvalidProvenanceError
      end
    end

    it "the provenance is correct on the facts in the added resources" do
      resources_with_provenance_and_resources.each do |resource|
        resource.each do |fact|
          fact.provenance_subject.should == resources_with_provenance_and_resources.provenance_resource.subject
        end
      end
    end

    describe "the collection" do
      it "fact resources can be added" do
        resources_with_provenance_and_resources # should not raise_exception
      end
    end

    it "Factories work" do
      full_factory = Factories::ResourcesWithProvenance.full_factory
      full_factory.size.should == 2
    end
  end
end
