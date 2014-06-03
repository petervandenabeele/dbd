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
          expect(context.first.subject).to eq context_subject
        end

        it 'works with an array of contexts_facts' do
          context << [context_visibility_with_correct_subject]
          expect(context.first.subject).to eq context_subject
        end

        it 'returns self' do
          expect(context << [context_visibility_with_correct_subject]).to be_a(Context)
        end

        it 'with incorrect subject it raises SetOnceError' do
          expect{ context << context_visibility_with_incorrect_subject }.to raise_error(
            RubyPeterV::SetOnceError,
            "Value of subject was #{context_visibility_with_incorrect_subject.subject}, " \
            "trying to set it to #{context.subject}"
          )
        end

        it 'with nil subject it sets the subject' do
          context << context_fact_visibility
          expect(context.first.subject).to eq context_subject
        end

        it 'with nil (=correct) context_subject it is a noop' do
          context << context_fact_visibility
          expect(context.first.context_subject).to be_nil
        end
      end

      describe 'adding facts with << ' do

        let(:fact) { TestFactories::Fact.fact_1 }

        it 'fails with ArgumentError' do
          expect{ context << fact }.to raise_error(
            ArgumentError,
            'Trying to add a non-ContextFact to a Context.'
          )
        end
      end
    end
  end
end
