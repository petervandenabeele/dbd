require 'spec_helper'

module Dbd
  describe Resource do

    let(:context_subject) { TestFactories::ContextFact.new_subject }
    let(:resource) { described_class.new }
    let(:resource_with_context_subject) { described_class.new(context_subject: context_subject) }

    describe '.new_subject' do
      it 'returns a Fact#new_subject' do
        described_class.new_subject.should be_a(Fact.factory.new_subject.class)
      end
    end

    describe '.new' do

      describe 'without a context_subject argument' do
        it 'has created a subject' do
          resource.subject.should be_a(described_class.new_subject.class)
        end

        it 'has a nil context_subject' do
          resource.context_subject.should be_nil
        end
      end

      describe 'with a context_subject argument' do
        it 'has created a subject' do
          resource_with_context_subject.subject.should be_a(described_class.new_subject.class)
        end

        it 'has stored the explicit context_subject' do
          resource_with_context_subject.context_subject.should == context_subject
        end
      end

      describe 'with an explicit subject argument' do
        it 'has stored the given subject' do
          explicit_subject = described_class.new_subject
          described_class.new(subject: explicit_subject).subject.should == explicit_subject
        end
      end
    end
  end
end
