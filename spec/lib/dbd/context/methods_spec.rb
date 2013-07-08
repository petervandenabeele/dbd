require 'spec_helper'

module Dbd
  describe Context do

    let(:subject) { described_class.factory.new_subject }

    let(:context_1) do
      TestFactories::Context.visibility(subject)
    end

    let(:context_created) do
      TestFactories::Context.created(subject)
    end

    describe 'short' do
      it 'for a context fact shows [ cont ], subj, predicate, object' do
        context_1.short.should match(/^\[ cont \] : [0-9a-f]{8} : context:visibility       : public$/)
      end

      it 'for a context fact with non string object also works' do
        context_created.short.should match(/^\[ cont \] : [0-9a-f]{8} : dcterms:created          : \d{4}/)
      end
    end

    describe 'errors' do
      it 'the factory has no errors' do
        context_1.errors.should be_empty
      end

      describe 'with a context_subject' do

        before(:each) do
          context_1.stub(:context_subject).and_return(subject)
        end

        it 'errors returns an array with 1 error message' do
          context_1.errors.single.should match(/Context subject should not be present in Context/)
        end
      end

      describe 'without subject' do

        before(:each) do
          context_1.stub(:subject).and_return(nil)
        end

        it 'errors returns an array with an error message' do
          context_1.errors.single.should match(/Subject is missing/)
        end
      end
    end

    describe 'update_used_context_subjects' do
      it 'does nothing for a context' do
        h = {}
        context_1.update_used_context_subjects(h)
        h.should be_empty
      end
    end

    describe 'attributes and values' do
      it 'there are 6 attributes' do
        described_class.attributes.size.should == 6
      end

      it 'there are 6 values' do
        context_1.values.size.should == 6
      end
    end

    describe 'context?' do
      it 'is true for Context or derived from it' do
        context_1.context?.should be_true
      end
    end
  end
end
