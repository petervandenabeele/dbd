require 'spec_helper'

module TestFactories
  describe Graph do
    describe 'with only provenance facts' do

      let(:only_provenance) { described_class.only_provenance }

      it 'is a Graph' do
        only_provenance.should be_a(described_class.factory_for)
      end

      it 'has some facts' do
        only_provenance.size.should >= 2
      end
    end

    describe 'with only facts' do

      let(:subject) { described_class.new_subject }
      let(:only_facts_without_provenance_subject) { described_class.only_facts }
      let(:only_facts_with_provenance_subject) { described_class.only_facts(subject) }

      describe 'only_facts_without_provenance_subject' do
        it 'is a Graph' do
          only_facts_without_provenance_subject.should be_a(described_class.factory_for)
        end

        it 'has some facts' do
          only_facts_without_provenance_subject.size.should >= 2
        end
      end

      describe 'only_facts_with_subject' do
        it 'is a Graph' do
          only_facts_with_provenance_subject.should be_a(described_class.factory_for)
        end

        it 'has the set subject' do
          only_facts_with_provenance_subject.first.provenance_subject.should == subject
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
