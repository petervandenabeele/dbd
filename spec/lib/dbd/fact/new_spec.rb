require 'spec_helper'

module Dbd
  describe Fact do
    let(:factory) { described_class.factory}
    let(:context_subject) { factory.new_subject }
    let(:subject) { factory.new_subject }
    let(:fact_1) { TestFactories::Fact.fact_1(context_subject) }
    let(:fact_2_with_subject) { TestFactories::Fact.fact_2_with_subject(context_subject) }
    let(:data_predicate)  { 'http://example.org/test/name' }
    let(:string_object_1)  { 'Gandhi' }
    let(:id_valid_regexp) { described_class::ID.valid_regexp }
    let(:subject_valid_regexp) { described_class::Subject.valid_regexp }
    let(:forced_id) { described_class.factory.new_id }
    let(:fact_with_forced_id) { TestFactories::Fact.fact_with_forced_id(forced_id) }
    let(:time_stamp) { TimeStamp.new }
    let(:fact_with_time_stamp) { TestFactories::Fact.fact_with_time_stamp(time_stamp) }
    let(:fact_with_incorrect_time_stamp) { TestFactories::Fact.fact_with_time_stamp(time_stamp.time) }

    describe 'create a fact' do
      it 'has a unique id (matches id_valid_regexp)' do
        fact_1.id.should match(id_valid_regexp)
      end

      it 'two facts have different id' do
        fact_1.id.should_not == fact_2_with_subject.id
      end

      it 'optionally sets the id' do
        fact_with_forced_id.id.should == forced_id
      end

      it 'optionally sets the time_stamp' do
        fact_with_time_stamp.time_stamp.should == time_stamp
      end

      it 'setting the time_stamp to a non TimeStamp raises ArgumentError' do
        lambda{ fact_with_incorrect_time_stamp }.should raise_error(ArgumentError)
      end

      it 'new sets the context_subject' do
        fact_1.context_subject.should == context_subject
      end

      it 'new sets the subject' do
        fact_2_with_subject.subject.should match(subject_valid_regexp)
      end

      it 'a nil predicate raises PredicateError' do
        lambda do
          described_class.new(
            predicate: nil,
            object: string_object_1)
        end.should raise_error(PredicateError)
      end

      it 'a nil object raises ObjectError' do
        lambda do
          described_class.new(
            predicate: data_predicate,
            object: nil)
        end.should raise_error(ObjectError)
      end
    end

    describe 'create fact_1' do
      describe 'with a string object type' do
        it 'new sets the predicate' do
          fact_1.predicate.should == data_predicate
        end

        it 'new sets the object' do
          fact_1.object.should == string_object_1
        end
      end
    end

    describe 'update_used_context_subjects' do
      it 'sets the value for context_subject to true for a fact' do
        h = {}
        fact_1.update_used_context_subjects(h)
        h[fact_1.context_subject].should == true
      end
    end
  end
end
