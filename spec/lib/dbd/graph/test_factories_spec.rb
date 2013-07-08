require 'spec_helper'

module TestFactories
  describe Graph do
    describe 'with only context_facts' do

      let(:only_context) { described_class.only_context }

      it 'is a Graph' do
        only_context.should be_a(described_class.factory_for)
      end

      it 'has some facts' do
        only_context.size.should >= 2
      end
    end

    describe 'with only facts' do

      let(:subject) { described_class.new_subject }
      let(:only_facts_without_context_subject) { described_class.only_facts }
      let(:only_facts_with_context_subject) { described_class.only_facts(subject) }

      describe 'only_facts_without_context_subject' do
        it 'is a Graph' do
          only_facts_without_context_subject.should be_a(described_class.factory_for)
        end

        it 'has some facts' do
          only_facts_without_context_subject.size.should >= 2
        end
      end

      describe 'only_facts_with_subject' do
        it 'is a Graph' do
          only_facts_with_context_subject.should be_a(described_class.factory_for)
        end

        it 'has the set subject' do
          only_facts_with_context_subject.first.context_subject.should == subject
        end
      end
    end

    describe 'full' do

      let(:full) { described_class.full }

      it 'is a Graph' do
        full.should be_a(described_class.factory_for)
      end

      it 'full has many facts' do
        full.size.should >= 4
      end
    end
  end
end
