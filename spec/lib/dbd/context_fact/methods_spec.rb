require 'spec_helper'

module Dbd
  describe ContextFact do

    let(:subject) { described_class.factory.new_subject }

    let(:context_fact_1) do
      TestFactories::ContextFact.visibility(subject)
    end

    let(:context_fact_created) do
      TestFactories::ContextFact.created(subject)
    end

    describe 'short' do
      it 'for a context_fact fact shows [ cont ], subj, predicate, object' do
        context_fact_1.short.should match(/^\[ cont \] : [0-9a-f]{8} : context:visibility       : public$/)
      end

      it 'for a context_fact fact with non string object also works' do
        context_fact_created.short.should match(/^\[ cont \] : [0-9a-f]{8} : dcterms:created          : \d{4}/)
      end
    end

    describe 'errors' do
      it 'the factory has no errors' do
        context_fact_1.errors.should be_empty
      end

      describe 'with a context_subject' do

        before(:each) do
          context_fact_1.stub(:context_subject).and_return(subject)
        end

        it 'errors returns an array with 1 error message' do
          context_fact_1.errors.single.should match(/ContextFact subject should not be present in ContextFact/)
        end
      end

      describe 'without subject' do

        before(:each) do
          context_fact_1.stub(:subject).and_return(nil)
        end

        it 'errors returns an array with an error message' do
          context_fact_1.errors.single.should match(/Subject is missing/)
        end
      end
    end

    describe 'attributes and values' do
      it 'there are 7 attributes' do
        described_class.attributes.size.should == 7
      end

      it 'there are 7 values' do
        context_fact_1.values.size.should == 7
      end
    end

    describe 'context_fact?' do
      it 'is true for ContextFact or derived from it' do
        expect(context_fact_1.context_fact?).to eq true
      end
    end
  end
end
