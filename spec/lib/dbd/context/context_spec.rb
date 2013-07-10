require 'spec_helper'

module Dbd
  describe Context do

    let(:context) { described_class.new }
    let(:context_subject) { context.subject }

    describe '.new' do
      describe 'without a subject argument' do
        it 'has created a new subject' do
          context.subject.should be_a(described_class.new_subject.class)
        end
      end

      describe 'with a subject argument' do
        it 'has stored the resource_subject' do
          described_class.new(subject: context_subject).subject.
            should == context_subject
        end
      end

      describe 'with a context_subject argument' do
        it 'raises an ContextError' do
          lambda{ described_class.new(context_subject: context_subject) }.
            should raise_error(ArgumentError)
        end
      end
    end

    describe 'context_subject' do
      it 'raises NoMethodError when called' do
        lambda{ context.context_subject }.should raise_error(NoMethodError)
      end
    end

    describe 'TestFactories::Context' do
      it '.context works' do
        TestFactories::Context.context
      end
    end

    describe 'the collection' do

      let(:context_fact_visibility) { TestFactories::ContextFact.visibility } # nil subject
      let(:context_visibility_with_incorrect_subject) { TestFactories::ContextFact.visibility(TestFactories::ContextFact.new_subject) }
      let(:context_visibility_with_correct_subject) { TestFactories::ContextFact.visibility(context_subject) }

      describe 'adding context_facts with << ' do
        it 'with correct subject it works' do
          context << context_visibility_with_correct_subject
          context.first.subject.should == context_subject
        end

        it 'with incorrect subject it raises SetOnceError' do
          lambda{ context << context_visibility_with_incorrect_subject }.
            should raise_error(RubyPeterV::SetOnceError),
              "Value of subject was #{context_visibility_with_incorrect_subject.subject}, " \
              "trying to set it to #{context.subject}"
        end

        it 'with nil subject it sets the subject' do
          context << context_fact_visibility
          context.first.subject.should == context_subject
        end

        it 'with nil (=correct) context_subject it is a noop' do
          context << context_fact_visibility
          context.first.context_subject.should be_nil
        end
      end
    end
  end
end
