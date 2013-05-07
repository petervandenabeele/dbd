require 'spec_helper'

module Dbd
  module Fact
    describe Base do
      let(:provenance_fact_subject) { Factories::ProvenanceFact.context.subject }
      let(:subject) { UUIDTools::UUID.random_create }
      let(:data_predicate)  { "http://example.org/test/name" }
      let(:string_object_1)  { "Gandhi" }
      let(:string_object_2)  { "Mandela" }

      # fact_1 is a data_fact
      let(:fact_1) do
        described_class.new(
          provenance_fact_subject,
          subject,
          data_predicate,
          string_object_1)
      end

      # fact_2 may be an object_fact later
      let(:fact_2) do
        described_class.new(
          provenance_fact_subject,
          subject,
          data_predicate,
          string_object_2)
      end

      describe "create a fact" do
        it "has a unique id (UUID)" do
          fact_1.id.should be_a(UUIDTools::UUID)
        end

        it "two facts have different id" do
          fact_1.id.should_not == fact_2.id
        end

        it "has a very fine grained time stamp" do
          fact_1.time_stamp.should be_a(Time)
        end

        it "the time_stamps of 2 consecutive created facts should be different" do
          fact_1.time_stamp.should < fact_2.time_stamp
        end

        it "new needs a provenance_fact_subject" do
          fact_1.provenance_fact_subject.should == provenance_fact_subject
        end

        it "new stores a subject" do
          fact_1.subject.should == subject
        end
      end

      describe "create a data_fact" do
        describe "with a string object type" do
          it "new stores a predicate" do
            fact_1.predicate.should == data_predicate
          end

          it "new stores a String object" do
            fact_1.object.should == string_object_1
          end
        end
      end

      describe "attributes and values" do
        it "there are 6 attributes" do
          described_class.attributes.size.should == 6
        end

        it "first attribute is :id" do
          described_class.attributes.first.should == :id
        end

        it "there are 6 values" do
          fact_1.values.size.should == 6
        end

        it "second value is a time_stamp" do
          fact_1.values[1].should be_a(Time)
        end
      end

      describe "update_provenance_fact_subject" do
        it "sets the value for provenance_fact_subject to true for a fact" do
          h = {}
          fact_1.update_provenance_fact_subject(h)
          h[fact_1.provenance_fact_subject].should == true
        end
      end

      describe "factory works" do
        it "without provenance_fact_subject" do
          fact_1 = Factories::Fact.fact_1
          fact_1.provenance_fact_subject.should be_a(provenance_fact_subject.class)
          fact_1.subject.should be_a(subject.class)
          fact_1.predicate.should be_a(data_predicate.class)
          fact_1.object.should be_a(string_object_1.class)
        end

        it "with an explicit provenance_fact_subject" do
          fact_1 = Factories::Fact.fact_1(provenance_fact_subject)
          fact_1.provenance_fact_subject.should == provenance_fact_subject
        end
      end
    end
  end
end
