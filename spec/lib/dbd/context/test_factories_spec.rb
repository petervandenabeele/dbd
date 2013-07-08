require 'spec_helper'

module TestFactories
  describe Context do

    describe 'TestFactories do not fail' do
      it 'TestFactories::Context.visibility is OK' do
        described_class.visibility.should_not be_nil
      end

      it 'TestFactories::Context.created_by is OK' do
        described_class.created_by.should_not be_nil
      end

      it 'TestFactories::Context.original_source is OK' do
        described_class.original_source.should_not be_nil
      end

      it 'TestFactories::Context.new_subject is OK' do
        described_class.new_subject.should be_a(Context.new_subject.class)
      end
    end
  end
end
