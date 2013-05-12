require 'spec_helper'

module Dbd
  describe Resource do

    let(:resource_subject) { Fact.new_subject }
    let(:provenance_subject) { ProvenanceFact.new_subject }

    let(:resource) do
      described_class.new(resource_subject, provenance_subject)
    end

    describe ".new" do
      describe "with a subject and provenance_subject argument" do
        it "has stored the resource_subject" do
          resource.subject.should == resource_subject
        end

        it "has stored the provenance_subject" do
          resource.provenance_subject.should == provenance_subject
        end
      end

      describe "with a nil subject argument" do
        it "raises InvalidSubjectError" do
          lambda { described_class.new(nil, provenance_subject) } . should raise_error described_class::InvalidSubjectError
        end
      end

      describe "with a nil provenance_subject argument" do
        it "raises InvalidProvenanceError" do
          lambda { described_class.new(resource_subject, nil) } . should raise_error described_class::InvalidProvenanceError
        end
      end
    end

    describe "the fact collection" do

      let(:fact_2_with_subject) { Factories::Fact.fact_2_with_subject }
      let(:fact_3_with_subject) { Factories::Fact.fact_3_with_subject }
      let(:fact_without_subject) { Factories::Fact.data_fact }
      let(:fact_with_provenance) { Factories::Fact.data_fact(provenance_subject, nil) }
      let(:fact_with_resource_subject) { Factories::Fact.data_fact(nil, resource_subject) }
      let(:fact_with_provenance_and_resource_subject) { Factories::Fact.data_fact(provenance_subject, resource_subject) }
      let(:fact_with_incorrect_provenance) { Factories::Fact.data_fact(Factories::ProvenanceFact.new_subject, resource_subject) }
      let(:provenance_fact_context) { Factories::ProvenanceFact.context }

      it "enumerable functions work" do
        resource.to_a.should == []
      end

      describe "#<<" do

        it "can add a two facts (no subject set)" do
          resource << fact_without_subject
          resource << fact_with_provenance
          resource.size.should == 2
        end

        describe "checks and sets subject :" do
          describe "adding a fact with subject :" do
            describe "when the subject of the fact is equal to the resource_subject" do
              it "inserts the fact unaltered" do
                resource << fact_with_provenance_and_resource_subject
                resource.first.should be_equal(fact_with_provenance_and_resource_subject)
              end
            end

            describe "when the subject of the fact is not equal to the resource_subject" do
              it "raises an InvalidSubjectError" do
                lambda {resource << fact_2_with_subject } . should raise_error described_class::InvalidSubjectError
              end
            end
          end

          describe "adding a fact without subject" do

            let (:new_fact) do
              resource << fact_with_provenance
              resource.first
            end

            it "insert a different instance" do
              new_fact.should_not be_equal(fact_with_provenance)
            end

            it "is from the same class" do
              new_fact.should be_a(fact_with_provenance.class)
            end

            it "has copied over the other attributes except :id" do
              (fact_with_provenance.class.attributes - [:id,:subject]).each do |attr|
                new_fact.send(attr).should == fact_with_provenance.send(attr)
              end
            end

            it "has set the subject to the Resource subject" do
              new_fact.subject.should == resource_subject
            end
          end
        end

        describe "checks and sets provenance_subject :" do
          describe "adding a fact with a provenance subject :" do
            describe "when the provenance_subject of the fact is equal to the provenance_subject of the resource" do
              it "inserts the fact unaltered" do
                resource << fact_with_provenance_and_resource_subject
                resource.first.should be_equal(fact_with_provenance_and_resource_subject)
              end
            end

            describe "when the provenance_subject of the fact is not equal to the resource" do
              it "raises an InvalidProvenanceError" do
                lambda {resource << fact_with_incorrect_provenance } . should raise_error described_class::InvalidProvenanceError
              end
            end
          end

          describe "adding a fact without provenance_subject" do

            let (:new_fact) do
              resource << fact_with_resource_subject
              resource.first
            end

            it "insert a different instance" do
              new_fact.should_not be_equal(fact_with_resource_subject)
            end

            it "is from the same class" do
              new_fact.should be_a(fact_with_resource_subject.class)
            end

            it "has copied over the other attributes except :id" do
              (new_fact.class.attributes - [:id,:provenance_subject]).each do |attr|
                new_fact.send(attr).should == fact_with_resource_subject.send(attr)
              end
            end

            it "has set the subject to the Resource subject" do
              new_fact.provenance_subject.should == provenance_subject
            end
          end
        end

      end
    end

    describe "Factories::Resource" do
      it ".facts_resource works" do
        Factories::Resource.facts_resource(provenance_subject)
      end
    end
  end
end
