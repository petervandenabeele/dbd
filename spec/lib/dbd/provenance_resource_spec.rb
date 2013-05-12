require 'spec_helper'

module Dbd
  describe ProvenanceResource do

    let(:provenance_resource) { described_class.new }
    let(:provenance_resource_subject) { provenance_resource.subject }

    describe ".new" do
      describe "without a subject argument" do
        it "has created a new subject" do
          provenance_resource.subject.should be_a(described_class.new_subject.class)
        end
      end

      describe "with a subject argument" do
        it "has stored the resource_subject" do
          described_class.new(subject: provenance_resource_subject).subject.should == provenance_resource_subject
        end
      end

      describe "with a provenance_subject argument" do
        it "raises an ProvenanceError" do
          lambda { described_class.new(provenance_subject: provenance_resource_subject) } .
            should raise_error ProvenanceError
        end
      end
    end

    describe "provenance_subject" do
      it "raises NoMethodError when called" do
        lambda { provenance_resource.provenance_subject } . should raise_error NoMethodError
      end
    end

    describe "Factories::Resource" do
      it ".provenance_resource works" do
        Factories::ProvenanceResource.provenance_resource
      end
    end

    describe "the collection" do

      let(:provenance_fact_context) { Factories::ProvenanceFact.context }
      let(:provenance_fact_context_with_incorrect_subject) { Factories::ProvenanceFact.context(Factories::ProvenanceFact.new_subject) }
      let(:provenance_fact_context_with_correct_subject) { Factories::ProvenanceFact.context(provenance_resource_subject) }
      let(:fact_1) { Factories::Fact.fact_1(provenance_resource_subject) }

      describe "data facts" do
        it "with correct subject" do
          provenance_resource << provenance_fact_context_with_correct_subject
          provenance_resource.first.subject.should == provenance_resource_subject
        end

        it "with incorrect subject it raise SubjectError" do
          lambda { provenance_resource << provenance_fact_context_with_incorrect_subject } .
            should raise_error SubjectError
        end

        it "with nil subject" do
          provenance_resource << provenance_fact_context
          provenance_resource.first.subject.should == provenance_resource_subject
        end

        it "with nil (=correct) provenance_subject" do
          provenance_resource << provenance_fact_context
          provenance_resource.first.provenance_subject.should be_nil
        end

        it "with incorrect provenance_subjecti ProvenanceError" do
          lambda { provenance_resource << fact_1 } .
            should raise_error ProvenanceError
        end
      end
    end
  end
end
