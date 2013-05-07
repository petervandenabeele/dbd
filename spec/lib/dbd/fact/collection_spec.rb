require 'spec_helper'

module Dbd
  module Fact
    describe Collection do

      let(:fact_1) { Factories::Fact.fact_1 }
      let(:fact_2) { Factories::Fact.fact_2 }

      let(:provenance_fact_context) { Factories::ProvenanceFact.context }
      let(:provenance_fact_subject) { provenance_fact_context.subject }
      let(:provenance_fact_created_by) { Factories::ProvenanceFact.created_by(provenance_fact_subject) }
      let(:fact_1_2) { Factories::Fact::Collection.fact_1_2(provenance_fact_subject) }

      describe "create a facts collection" do
        it "new does not fail" do
          subject.should_not be_nil
        end

        it "the collection is not an array" do
          subject.should_not be_a(Array)
        end

        it "the collection has Enumerable methods" do
          subject.map #should_not raise_exception
        end

        it "adding an element works" do
          subject << fact_1
          subject.count.should == 1
        end

        it "first entry should be a Fact::Base" do
          subject << fact_1
          subject.first.should be_a(Fact::Base)
        end

        it "other functions (e.g. []) do not work" do
          subject << fact_1
          lambda { subject[0] } . should raise_exception NoMethodError
        end

        it "<< returns self, so chaining is possible" do
          (subject << fact_1).should == subject
        end
      end

      describe "newest_time_stamp" do
        it "returns nil for empty collection" do
          subject.newest_time_stamp.should be_nil
        end

        it "returns a time_stamp" do
          subject << fact_1
          subject.newest_time_stamp.should be_a(fact_1.time_stamp.class)
        end

        it "returns the newest time_stamp" do
          subject << fact_1
          subject << fact_2
          subject.newest_time_stamp.should == fact_2.time_stamp
        end
      end

      describe "validate that only 'newer' elements are added" do
        it "adding an element with a newer time_stamp succeeds" do
          subject << fact_1
          subject << fact_2
        end

        it "adding an element with an older time_stamp fails" do
          fact_1 # will be older then fact_2
          subject << fact_2
          lambda { subject << fact_1 } . should raise_error(Collection::OutOfOrderError)
        end

        it "adding an element with an equal time_stamp fails" do
          fact_1
          subject << fact_1
          lambda { subject << fact_1 } . should raise_error(Collection::OutOfOrderError)
        end
      end

      describe "oldest_time_stamp" do
        it "returns nil for empty collection" do
          subject.oldest_time_stamp.should be_nil
        end

        it "returns a time_stamp" do
          subject << fact_1
          subject.oldest_time_stamp.should be_a(fact_1.time_stamp.class)
        end

        it "returns the oldest time_stamp" do
          subject << fact_1
          subject << fact_2
          subject.oldest_time_stamp.should == fact_1.time_stamp
        end
      end

      # A hash with all the provenance_fact subjects that are used by a fact
      describe "a hash with all the provenance_fact subjects that are used by at least one fact" do
        it "exists" do
          subject.provenance_fact_subjects.should_not be_nil
        end

        it "is empty initially" do
          subject.provenance_fact_subjects.should be_empty
        end

        it "adding a provenance_fact and a fact create an entry" do
          subject << fact_1
          subject << provenance_fact_context
        end
      end

      describe "Factories::Fact::Collection" do
        it ".fact_1_2 does not fail" do
          fact_1_2 # should not raise_error
        end

        it "uses provenance_fact_id if supplied" do
          provenance_fact_id = provenance_fact_context.id
          subject = Factories::Fact::Collection.fact_1_2(provenance_fact_id)
          subject.each do |fact|
            fact.provenance_fact_id.should == provenance_fact_id
          end
        end
      end

      let(:subject_1) { UUIDTools::UUID.random_create }
      let(:provenance_fact_context) { Factories::ProvenanceFact.context(subject_1) }
      let(:provenance_fact_created_by) { Factories::ProvenanceFact.created_by(subject_1) }
      let(:provenance_fact_original_source) { Factories::ProvenanceFact.original_source }

      describe "<< : " do
        it "adding an element works" do
          subject << provenance_fact_context
          subject.count.should == 1
        end

        it "returns self to allow chaining" do
          (subject << provenance_fact_context).should == subject
        end
      end

      describe "by_subject : " do
        it "finds entries for a given subject" do
          subject << provenance_fact_context
          subject << provenance_fact_created_by
          subject << provenance_fact_original_source
          provenance_fact_context.subject.should == subject_1 # assert test set-up
          provenance_fact_created_by.subject.should == subject_1 # assert test set-up
          subject_2 = provenance_fact_original_source.subject
          subject.by_subject(subject_1).first.should == provenance_fact_context
          subject.by_subject(subject_1).last.should == provenance_fact_created_by
          subject.by_subject(subject_2).single.should == provenance_fact_original_source
        end
      end

      describe "Factories::Fact::Collection.provenance_facts" do

        let (:collection) { Factories::Fact::Collection.provenance_facts }

        it "has a context" do
          collection.select do |provenance_fact|
            provenance_fact.property == "https://data.vandenabeele.com/ontologies/provenance#context"
          end.size.should == 1
        end

        it "has a created_by" do
          collection.select do |provenance_fact|
            provenance_fact.property == "https://data.vandenabeele.com/ontologies/provenance#created_by"
          end.size.should == 1
        end

        it "has an original_source" do
          collection.select do |provenance_fact|
            provenance_fact.property == "https://data.vandenabeele.com/ontologies/provenance#original_source"
          end.size.should == 1
        end

        describe "with subject argument" do
          it "provenance_facts have different subjects without subject arg" do
            collection.first.subject.should_not == collection.to_a[1].subject
          end

          it "provenance_facts have different subjects with explicit subject arg" do
            collection = Factories::Fact::Collection.provenance_facts(subject_1)
            collection.first.subject.should == subject_1
            collection.to_a[1].subject.should == subject_1
          end
        end
      end
    end
  end
end
