require 'spec_helper'

module Dbd
  describe ProvenanceResource do

    let(:resource_subject) { Fact.new_subject }
    let(:provenance_resource) { described_class.new(resource_subject) }

    describe ".new" do
      describe "with a subject argument" do
        it "has stored the resource_subject" do
          provenance_resource.subject.should == resource_subject
        end
      end

      describe "with a nil subject argument" do
        it "raises InvalidSubjectError" do
          lambda { described_class.new(nil) } . should raise_error described_class::InvalidSubjectError
        end
      end
    end

    describe "provenance_subject" do
      it "raises RuntimeError when called" do
        lambda { provenance_resource.provenance_subject } . should raise_error RuntimeError
      end
    end
  end
end
