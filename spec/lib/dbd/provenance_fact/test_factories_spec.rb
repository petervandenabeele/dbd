require 'spec_helper'

module TestFactories
  describe ProvenanceFact do

    describe 'TestFactories do not fail' do
      it 'TestFactories::ProvenanceFact.context is OK' do
        described_class.context.should_not be_nil
      end

      it 'TestFactories::ProvenanceFact.created_by is OK' do
        described_class.created_by.should_not be_nil
      end

      it 'TestFactories::ProvenanceFact.original_source is OK' do
        described_class.original_source.should_not be_nil
      end

      it 'TestFactories::ProvenanceFact.new_subject is OK' do
        described_class.new_subject.should be_a(ProvenanceFact.new_subject.class)
      end
    end
  end
end
