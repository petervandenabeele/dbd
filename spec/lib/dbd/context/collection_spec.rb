require 'spec_helper'

module Dbd
  describe Context do

    let(:context) { described_class.new }
    let(:context_subject) { context.subject }

    describe 'the collection' do

      let(:context_fact_visibility) { TestFactories::ContextFact.visibility } # nil subject
      let(:context_visibility_with_incorrect_subject) { TestFactories::ContextFact.visibility(TestFactories::ContextFact.new_subject) }
      let(:context_visibility_with_correct_subject) { TestFactories::ContextFact.visibility(context_subject) }

      describe 'adding context_facts with << ' do
        it 'with correct subject it works' do
          context << context_visibility_with_correct_subject
          context.first.subject.should == context_subject
        end

        it 'works with an array of contexts_facts' do
          context << [context_visibility_with_correct_subject]
          context.first.subject.should == context_subject
        end

        it 'returns self' do
          (context << [context_visibility_with_correct_subject]).should be_a(Context)
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
