require 'spec_helper'

module Dbd
  class Fact
    describe Collection do

      let(:context_subject_1) { Fact.factory.new_subject }
      let(:context_subject_2) { Fact.factory.new_subject }

      let(:context_fact_visibility) { TestFactories::ContextFact.visibility(context_subject_1) }
      let(:context_fact_created_by) { TestFactories::ContextFact.created_by(context_subject_1) }
      let(:context_fact_original_source) { TestFactories::ContextFact.original_source(context_subject_2) }

      let(:fact_1) { TestFactories::Fact.fact_1(context_subject_1) }
      let(:fact_2_with_subject) { TestFactories::Fact.fact_2_with_subject(context_subject_1) }
      let(:fact_3_with_subject) { TestFactories::Fact.fact_3_with_subject(context_subject_1) }

      let(:fact_2_3) { TestFactories::Fact::Collection.fact_2_3(context_subject_1) }
      let(:context_facts) { TestFactories::Fact::Collection.context_facts(context_subject_1) }

      let(:subject) do
        Object.new.tap do |object_with_Fact_Collection|
          object_with_Fact_Collection.extend(described_class)
          object_with_Fact_Collection.send(:initialize)
        end
      end

      describe '.new : ' do
        it 'the collection is not an array' do
          subject.should_not be_a(Array)
        end

        it 'the collection has Enumerable methods' do
          subject.map #should_not raise_exception
        end
      end

      describe '.methods : ' do

        describe '#<< : ' do
          it 'adding a fact works' do
            subject << fact_2_with_subject
            subject.size.should == 1
          end

          it 'adding a context_fact works' do
            subject << context_fact_visibility
            subject.size.should == 1
          end

          it 'returns self to allow chaining' do
            (subject << context_fact_visibility).should == subject
          end
        end

        it '#first should be a Fact' do
          subject << fact_2_with_subject
          subject.first.should be_a(Fact)
        end

        it 'other functions (e.g. []) do not work' do
          subject << fact_2_with_subject
          lambda { subject[0] } . should raise_exception NoMethodError
        end

        it '#<< returns self, so chaining is possible' do
          (subject << fact_2_with_subject).should == subject
        end
      end

      describe 'adding a fact with a ref to a context_fact' do

        it 'fact_2_with_subject has a context_subject that refers to context_fact_visibility and context_fact_created_by' do
          subject << context_fact_visibility
          subject << context_fact_created_by
          subject << fact_2_with_subject
          context_subject = fact_1.context_subject
          subject.by_subject(context_subject).should == [context_fact_visibility, context_fact_created_by]
        end
      end

      describe 'newest_time_stamp' do
        it 'returns nil for empty collection' do
          subject.newest_time_stamp.should be_nil
        end

        it 'returns a time_stamp' do
          subject << fact_2_with_subject
          subject.newest_time_stamp.should be_a(fact_2_with_subject.time_stamp.class)
        end

        it 'returns the newest time_stamp' do
          subject << fact_2_with_subject
          subject << fact_3_with_subject
          subject.newest_time_stamp.should == fact_3_with_subject.time_stamp
        end
      end

      describe 'validate that only "newer" elements are added' do
        before(:each) do
          fact_2_with_subject.stub(:time_stamp).and_return(TimeStamp.new(time: Time.utc(2013,05,9,12,0,0)))
          fact_3_with_subject.stub(:time_stamp).and_return(TimeStamp.new(time: Time.utc(2013,05,9,12,0,1)))
        end

        it 'adding an element with a newer time_stamp succeeds' do
          subject << fact_2_with_subject
          subject << fact_3_with_subject
        end

        it 'adding an element with an older time_stamp fails' do
          fact_2_with_subject # will be older then fact_3_with_subject
          subject << fact_3_with_subject
          lambda { subject << fact_2_with_subject } . should raise_error OutOfOrderError
        end

        it 'adding an element with an equal time_stamp fails' do
          subject << fact_2_with_subject
          lambda { subject << fact_2_with_subject } . should raise_error OutOfOrderError
        end
      end

      describe 'oldest_time_stamp' do
        it 'returns nil for empty collection' do
          subject.oldest_time_stamp.should be_nil
        end

        it 'returns a time_stamp' do
          subject << fact_2_with_subject
          subject.oldest_time_stamp.should be_a(fact_2_with_subject.time_stamp.class)
        end

        it 'returns the oldest time_stamp' do
          subject << fact_2_with_subject
          subject << fact_3_with_subject
          subject.oldest_time_stamp.should == fact_2_with_subject.time_stamp
        end
      end

      describe 'validate that facts do not have errors when loading in the Fact::Collection' do
        it 'succeeds with a fact from factory' do
           subject << fact_2_with_subject # should_not raise_error
        end

        it 'raises FactError with message when fact.errors has errors' do
           context_fact_visibility.stub(:errors).and_return(['Error 1', 'Error 2'])
           lambda { subject << context_fact_visibility } . should raise_error(
             FactError,
             'Error 1, Error 2.')
        end
      end

      describe 'by_subject : ' do
        it 'finds entries for a given subject' do
          subject << context_fact_visibility
          subject << context_fact_created_by
          subject << context_fact_original_source
          context_fact_visibility.subject.should == context_subject_1 # assert test set-up
          context_fact_created_by.subject.should == context_subject_1 # assert test set-up
          context_fact_original_source.subject.should == context_subject_2 # assert test set-up
          subject.by_subject(context_subject_1).first.should == context_fact_visibility
          subject.by_subject(context_subject_1).last.should == context_fact_created_by
          subject.by_subject(context_subject_2).single.should == context_fact_original_source
        end
      end

      describe 'TestFactories::Fact::Collection' do
        describe '.fact_2_3' do
          it 'has the given context_subject with explicit subject arg' do
            fact_2_3.each do |fact|
              fact.context_subject.should == context_subject_1
            end
          end
        end

        describe '.context_facts' do
          it 'has a visibility' do
            context_facts.select do |context_fact|
              context_fact.predicate == 'context:visibility'
            end.size.should == 1
          end

          it 'has a created_by' do
            context_facts.select do |context_fact|
              context_fact.predicate == 'dcterms:creator'
            end.size.should == 1
          end

          it 'has an original_source' do
            context_facts.select do |context_fact|
              context_fact.predicate == 'prov:source'
            end.size.should == 1
          end

          it 'has the given subjects with explicit subject arg' do
            context_facts.each do |context_fact|
              context_fact.subject.should == context_subject_1
            end
          end
        end
      end
    end
  end
end
