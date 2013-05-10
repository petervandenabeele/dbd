require 'spec_helper'

module Dbd
  class Fact
    describe Collection do

      let(:provenance_fact_subject_1) { ProvenanceFact.new_subject }

      let(:provenance_fact_context) { Factories::ProvenanceFact.context(provenance_fact_subject_1) }
      let(:provenance_fact_created_by) { Factories::ProvenanceFact.created_by(provenance_fact_subject_1) }
      let(:provenance_fact_original_source) { Factories::ProvenanceFact.original_source }

      let(:fact_1) { Factories::Fact.fact_1(provenance_fact_subject_1) }
      let(:fact_2_with_subject) { Factories::Fact.fact_2_with_subject(provenance_fact_subject_1) }
      let(:fact_3_with_subject) { Factories::Fact.fact_3_with_subject(provenance_fact_subject_1) }
      let(:fact_1_2) { Factories::Fact::Collection.fact_1_2(provenance_fact_subject_1) }

      describe ".new : " do
        it "the collection is not an array" do
          subject.should_not be_a(Array)
        end

        it "the collection has Enumerable methods" do
          subject.map #should_not raise_exception
        end
      end

      describe ".methods : " do

        describe "#<< : " do
          it "adding a fact works" do
            subject << fact_2_with_subject
            subject.count.should == 1
          end

          it "adding a provenance_fact works" do
            subject << provenance_fact_context
            subject.count.should == 1
          end

          it "returns self to allow chaining" do
            (subject << provenance_fact_context).should == subject
          end
        end

        it "#first should be a Fact" do
          subject << fact_2_with_subject
          subject.first.should be_a(Fact)
        end

        it "other functions (e.g. []) do not work" do
          subject << fact_2_with_subject
          lambda { subject[0] } . should raise_exception NoMethodError
        end

        it "#<< returns self, so chaining is possible" do
          (subject << fact_2_with_subject).should == subject
        end
      end

      describe "adding a fact with a ref to a provenance_fact" do

        it "fact_2_with_subject has a provenance_fact_subject that refers to context and created_by" do
          subject << provenance_fact_context
          subject << provenance_fact_created_by
          subject << fact_2_with_subject
          ps = fact_1.provenance_fact_subject
          subject.by_subject(ps).should == [provenance_fact_context, provenance_fact_created_by]
        end
      end

      describe "newest_time_stamp" do
        it "returns nil for empty collection" do
          subject.newest_time_stamp.should be_nil
        end

        it "returns a time_stamp" do
          subject << fact_2_with_subject
          subject.newest_time_stamp.should be_a(fact_2_with_subject.time_stamp.class)
        end

        it "returns the newest time_stamp" do
          subject << fact_2_with_subject
          subject << fact_3_with_subject
          subject.newest_time_stamp.should == fact_3_with_subject.time_stamp
        end
      end

      describe "validate that only 'newer' elements are added" do
        before(:each) do
          fact_2_with_subject.stub(:time_stamp).and_return(Time.new(2013,05,9,12,0,0))
          fact_3_with_subject.stub(:time_stamp).and_return(Time.new(2013,05,9,12,0,1))
        end

        it "adding an element with a newer time_stamp succeeds" do
          subject << fact_2_with_subject
          subject << fact_3_with_subject
        end

        it "adding an element with an older time_stamp fails" do
          fact_2_with_subject # will be older then fact_3_with_subject
          subject << fact_3_with_subject
          lambda { subject << fact_2_with_subject } . should raise_error(Collection::OutOfOrderError)
        end

        it "adding an element with an equal time_stamp fails" do
          subject << fact_2_with_subject
          lambda { subject << fact_2_with_subject } . should raise_error(Collection::OutOfOrderError)
        end
      end

      describe "oldest_time_stamp" do
        it "returns nil for empty collection" do
          subject.oldest_time_stamp.should be_nil
        end

        it "returns a time_stamp" do
          subject << fact_2_with_subject
          subject.oldest_time_stamp.should be_a(fact_2_with_subject.time_stamp.class)
        end

        it "returns the oldest time_stamp" do
          subject << fact_2_with_subject
          subject << fact_3_with_subject
          subject.oldest_time_stamp.should == fact_2_with_subject.time_stamp
        end
      end

      describe "provenance_facts must all come before first use by a fact" do
        it "adding a provenance_fact, depending fact, another provenance_fact with same subject fail" do
          subject << provenance_fact_context
          subject << fact_2_with_subject
          lambda { subject << provenance_fact_created_by } . should raise_error(Collection::OutOfOrderError)
        end

        # testing private functionality (kept temporarily as documentation)
        # A hash with all the provenance_fact subjects that are used by at least one fact.
        # Needed for the validation that no provenance_fact may be added about a fact that
        # is already in the fact stream.
        describe "provenance_fact_subject" do
          # testing an internal variable ...
          it "is empty initially" do
            subject.instance_variable_get(:@provenance_fact_subjects).should be_empty
          end

          it "adding a provenance_fact alone does not create an entry" do
            subject << provenance_fact_context
            subject.instance_variable_get(:@provenance_fact_subjects).should be_empty
          end

          it "adding a provenance_fact and a depending fact create an entry" do
            subject << provenance_fact_context
            subject << fact_2_with_subject
            subject.instance_variable_get(:@provenance_fact_subjects)[provenance_fact_subject_1].should == true
          end
        end
      end

      describe "validate that facts are complete? when loading in the Fact::Collection" do
        it "succeeds with a fact from factory" do
           subject << fact_2_with_subject # should_not raise_error
        end

        it "raises FactIncompleteError when fact.complete? is false" do
           provenance_fact_context.stub(:complete?).and_return(false)
           lambda { subject << provenance_fact_context } . should raise_error Collection::FactIncompleteError
        end
      end

      describe "Factories::Fact::Collection" do
        it ".fact_1_2 factory does not fail" do
          fact_1_2 # should not raise_error
        end

        it "uses provenance_fact_subject if supplied" do
          fact_1_2.each do |fact|
            fact.provenance_fact_subject.should == provenance_fact_subject_1
          end
        end
      end

      describe "by_subject : " do
        it "finds entries for a given subject" do
          subject << provenance_fact_context
          subject << provenance_fact_created_by
          # FIXME store a FactsWithProvenance object in the collection
          provenance_fact_original_source = self.provenance_fact_original_source
          provenance_fact_original_source.stub(:subject).and_return(ProvenanceFact.new_subject)
          subject << provenance_fact_original_source
          provenance_fact_context.subject.should == provenance_fact_subject_1 # assert test set-up
          provenance_fact_created_by.subject.should == provenance_fact_subject_1 # assert test set-up
          provenance_fact_subject_2 = provenance_fact_original_source.subject
          subject.by_subject(provenance_fact_subject_1).first.should == provenance_fact_context
          subject.by_subject(provenance_fact_subject_1).last.should == provenance_fact_created_by
          subject.by_subject(provenance_fact_subject_2).single.should == provenance_fact_original_source
        end
      end

      describe "Factories::Fact::Collection.provenance_facts" do

        let (:collection) { Factories::Fact::Collection.provenance_facts(provenance_fact_subject_1) }

        it "has a context" do
          collection.select do |provenance_fact|
            provenance_fact.predicate == "https://data.vandenabeele.com/ontologies/provenance#context"
          end.size.should == 1
        end

        it "has a created_by" do
          collection.select do |provenance_fact|
            provenance_fact.predicate == "https://data.vandenabeele.com/ontologies/provenance#created_by"
          end.size.should == 1
        end

        it "has an original_source" do
          collection.select do |provenance_fact|
            provenance_fact.predicate == "https://data.vandenabeele.com/ontologies/provenance#original_source"
          end.size.should == 1
        end

        describe "with subject argument" do
          it "provenance_facts have the given subjects with explicit subject arg" do
            collection.first.subject.should == provenance_fact_subject_1
            collection.to_a[1].subject.should == provenance_fact_subject_1
          end
        end
      end
    end
  end
end
