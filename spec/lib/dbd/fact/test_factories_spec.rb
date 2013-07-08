require 'spec_helper'

module TestFactories
  describe Fact do
    let(:context_subject) { Context.new_subject }
    let(:subject) { described_class.new_subject }
    let(:data_predicate)  { 'http://example.org/test/name' }
    let(:string_object_1)  { 'Gandhi' }
    let(:fact_2_with_subject) { described_class.fact_2_with_subject(context_subject) }
    let(:full_fact) { described_class.full_fact }

    describe 'factory works' do
      it 'with explicit context_subject' do
        fact_2_with_subject.context_subject.should be_a(context_subject.class)
        fact_2_with_subject.subject.should be_a(subject.class)
        fact_2_with_subject.predicate.should be_a(data_predicate.class)
        fact_2_with_subject.object.should be_a(string_object_1.class)
      end

      it 'without explicit context_subject' do
        described_class.fact_1.context_subject.should be_nil
      end

      it 'fact_2_with_subject should not raise_error' do
        described_class.fact_2_with_subject
      end

      it 'fact_3_with_subject should not raise_error' do
        described_class.fact_3_with_subject
      end

      describe 'data_fact' do
        describe 'without arguments' do
          it 'has empty context_subject' do
            described_class.data_fact.context_subject.should be_nil
          end

          it 'has empty subject' do
            described_class.data_fact.subject.should be_nil
          end
        end

        describe 'with context_subject' do
          it 'has context_subject' do
            described_class.data_fact(context_subject).
              context_subject.should == context_subject
          end

          it 'has empty subject' do
            described_class.data_fact(context_subject).subject.should be_nil
          end
        end

        describe 'with context_subject and subject' do
          it 'has context_subject' do
            described_class.data_fact(context_subject, subject).
              context_subject.should == context_subject
          end

          it 'has subject' do
            described_class.data_fact(context_subject, subject).
              subject.should == subject
          end
        end
      end

      describe 'full_fact' do
        it 'does not fail' do
          full_fact
        end

        it 'has values for all attributes' do
          full_fact.values.all?.should be_true
        end

        it 'is valid (no errors)' do
          full_fact.errors.should be_empty
        end
      end
    end
  end
end
