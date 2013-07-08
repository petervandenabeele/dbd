require 'spec_helper'

module TestFactories
  describe ContextFact do

    describe 'TestFactories do not fail' do
      it 'TestFactories::ContextFact.visibility is OK' do
        described_class.visibility.should_not be_nil
      end

      it 'TestFactories::ContextFact.created_by is OK' do
        described_class.created_by.should_not be_nil
      end

      it 'TestFactories::ContextFact.original_source is OK' do
        described_class.original_source.should_not be_nil
      end

      it 'TestFactories::ContextFact.new_subject is OK' do
        described_class.new_subject.should be_a(ContextFact.new_subject.class)
      end
    end
  end
end
