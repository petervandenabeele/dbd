require 'spec_helper'

module Dbd
  describe Resource do

    let(:provenance_subject) { Factories::ProvenanceResource.provenance_resource.subject }

    let(:resource) { described_class.new(provenance_subject: provenance_subject) }

    let(:resource_subject) { resource.subject }

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

        it "complains if a provenance_subject is added" do
          lambda{ resource << provenance_fact_context }.should raise_error(
            ArgumentError,
            "Trying to add a ProvenanceFact to a Resource.")
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
              it "raises a SetOnceError" do
                lambda{ resource << fact_2_with_subject }.should raise_error(
                  RubyPeterV::SetOnceError,
                  "Value of subject was #{fact_2_with_subject.subject}, " \
                  "trying to set it to #{resource.subject}")
              end
            end
          end

          describe "adding a fact without subject" do

            before(:each) do
              resource << fact_with_provenance
            end

            let(:fact_in_resource) do
              resource.single
            end

            it "insert the same instance" do
              fact_in_resource.should be_equal(fact_with_provenance)
            end

            it "has kept the other attributes" do
              (fact_with_provenance.class.attributes - [:subject]).each do |attr|
                fact_in_resource.send(attr).should == fact_with_provenance.send(attr)
              end
            end

            it "has set the subject to the Resource subject" do
              fact_in_resource.subject.should == resource_subject
            end
          end
        end

        describe "checks and sets provenance_subject :" do
          describe "adding a fact with a provenance subject :" do
            describe "when the provenance_subject of the fact is equal to the provenance_subject of the resource" do
              it "inserts the fact unaltered" do
                resource << fact_with_provenance_and_resource_subject
                resource.single.should be_equal(fact_with_provenance_and_resource_subject)
              end
            end

            describe "when the provenance_subject of the fact is not equal to the resource" do
              it "raises a SetOnceError" do
                lambda{ resource << fact_with_incorrect_provenance }.should raise_error(
                  RubyPeterV::SetOnceError,
                  "Value of provenance_subject was #{fact_with_incorrect_provenance.provenance_subject}, " \
                  "trying to set it to #{resource.provenance_subject}")
              end
            end
          end

          describe "adding a fact without provenance_subject" do

            before(:each) do
              resource << fact_with_resource_subject
            end

            let(:fact_in_resource) { resource.single }

            it "inserts the same instance" do
              fact_in_resource.should be_equal(fact_with_resource_subject)
            end

            it "has set the provenance_subject to the Resource provenance_subject" do
             fact_in_resource.provenance_subject.should == provenance_subject
            end
          end
        end
      end
    end
  end
end
