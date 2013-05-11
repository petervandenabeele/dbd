require 'spec_helper'

module Dbd
  describe ResourcesWithProvenance do

    let(:provenance_resource) { Factories::ProvenanceResource.provenance_resource }
    let(:facts_resource) { Factories::Resource.facts_resource }
    let(:provenance_subject) { provenance_resource.subject }

    let(:resources_with_provenance) do
      described_class.new(provenance_resource)
    end

    let(:resources_with_provenance_and_resources) do
      described_class.new(provenance_resource).tap do |rwp|
        rwp << facts_resource
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
