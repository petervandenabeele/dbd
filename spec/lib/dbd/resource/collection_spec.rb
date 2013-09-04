require 'spec_helper'

module Dbd
  describe Resource do

    let(:context_subject) { TestFactories::ContextFact.new_subject }
    let(:resource) { described_class.new(context_subject: context_subject) }
    let(:resource_subject) { resource.subject }

    describe 'the fact collection' do

      let(:fact_2_with_subject) { TestFactories::Fact.fact_2_with_subject }
      let(:fact_3_with_subject) { TestFactories::Fact.fact_3_with_subject }
      let(:fact_without_subject) { TestFactories::Fact.data_fact }
      let(:fact_with_context) { TestFactories::Fact.data_fact(context_subject, nil) }
      let(:fact_with_resource_subject) { TestFactories::Fact.data_fact(nil, resource_subject) }
      let(:fact_with_context_and_resource_subject) { TestFactories::Fact.data_fact(context_subject, resource_subject) }
      let(:fact_with_incorrect_context) { TestFactories::Fact.data_fact(TestFactories::ContextFact.new_subject, resource_subject) }
      let(:context_fact_visibility) { TestFactories::ContextFact.visibility }

      it 'enumerable functions work' do
        resource.to_a.should == []
      end

      describe '#<<' do

        it 'can add a two facts (no subject set)' do
          resource << fact_without_subject
          resource << fact_with_context
          resource.size.should == 2
        end

        it 'works with an array facts' do
          resource << [fact_without_subject, fact_with_context]
          resource.size.should == 2
          resource.first.should == fact_without_subject
          resource.last.should == fact_with_context
        end

        it 'returns self' do
          (resource << [fact_without_subject, fact_with_context]).should be_a(Resource)
        end

        it 'complains if a context_subject is added' do
          lambda{ resource << context_fact_visibility }.should raise_error(
            ArgumentError,
            'Trying to add a ContextFact to a Resource.')
         end

        describe 'checks and sets subject :' do
          describe 'adding a fact with subject :' do
            describe 'when the subject of the fact is equal to the resource_subject' do
              it 'inserts the fact unaltered' do
                resource << fact_with_context_and_resource_subject
                resource.first.should be_equal(fact_with_context_and_resource_subject)
              end
            end

            describe 'when the subject of the fact is not equal to the resource_subject' do
              it 'raises a SetOnceError' do
                lambda{ resource << fact_2_with_subject }.should raise_error(
                  RubyPeterV::SetOnceError,
                  "Value of subject was #{fact_2_with_subject.subject}, " \
                  "trying to set it to #{resource.subject}")
              end
            end
          end

          describe 'adding a fact without subject' do

            before(:each) do
              resource << fact_with_context
            end

            let(:fact_in_resource) do
              resource.single
            end

            it 'insert the same instance' do
              fact_in_resource.should be_equal(fact_with_context)
            end

            it 'has kept the other attributes' do
              (fact_with_context.class.attributes - [:subject]).each do |attr|
                fact_in_resource.send(attr).should == fact_with_context.send(attr)
              end
            end

            it 'has set the subject to the Resource subject' do
              fact_in_resource.subject.should == resource_subject
            end
          end
        end

        describe 'checks and sets context_subject :' do
          describe 'adding a fact with a context_fact subject :' do
            describe 'when the context_subject of the fact is equal to the context_subject of the resource' do
              it 'inserts the fact unaltered' do
                resource << fact_with_context_and_resource_subject
                resource.single.should be_equal(fact_with_context_and_resource_subject)
              end
            end

            describe 'when the context_subject of the fact is not equal to the resource' do
              it 'raises a SetOnceError' do
                lambda{ resource << fact_with_incorrect_context }.should raise_error(
                  RubyPeterV::SetOnceError,
                  "Value of context_subject was #{fact_with_incorrect_context.context_subject}, " \
                  "trying to set it to #{resource.context_subject}")
              end
            end
          end

          describe 'adding a fact without context_subject' do

            before(:each) do
              resource << fact_with_resource_subject
            end

            let(:fact_in_resource) { resource.single }

            it 'inserts the same instance' do
              fact_in_resource.should be_equal(fact_with_resource_subject)
            end

            it 'has set the context_subject to the Resource context_subject' do
             fact_in_resource.context_subject.should == context_subject
            end
          end
        end
      end
    end
  end
end
