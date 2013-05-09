require 'spec_helper'

module Dbd
  class FactsWithProvenance
    describe Collection do

=begin
      let(:subject_1) { Fact.new_subject }

      let(:provenance_fact_context) { Factories::ProvenanceFact.context(subject_1) }
      let(:provenance_fact_created_by) { Factories::ProvenanceFact.created_by(subject_1) }
      let(:provenance_fact_original_source) { Factories::ProvenanceFact.original_source }

      let(:fact_1) { Factories::Fact.fact_1(subject_1) }
      let(:fact_2) { Factories::Fact.fact_2(subject_1) }
      let(:fact_1_2) { Factories::Fact::Collection.fact_1_2(subject_1) }
=end

      let(:facts_by_subject_1) { FactsBySubject.new }
      let(:facts_by_subject_2) { FactsBySubject.new }

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
          it "adding a facts_by_subject object works" do
            subject << facts_by_subject_1
            subject.to_a.should == [facts_by_subject_1]
          end

          it "adding 2 facts_by_subject objects works" do
            subject << facts_by_subject_1
            subject << facts_by_subject_2
            subject.to_a.should == [facts_by_subject_1, facts_by_subject_2]
          end

          it "returns self to allow chaining" do
            (subject << facts_by_subject_1).should == subject
          end
        end
      end
    end
  end
end
