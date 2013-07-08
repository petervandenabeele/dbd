require 'spec_helper'

module Dbd
  class Fact
    describe Factory do

      let(:top_class) { described_class.top_class }
      let(:string_values) { TestFactories::Fact.string_values }
      let(:id_valid_regexp) { top_class::ID.valid_regexp }
      let(:subject_valid_regexp) { top_class::Subject.valid_regexp }

      describe '.new_subject' do
        it 'creates a new (random) subject' do
          described_class.new_subject.should match(subject_valid_regexp)
        end

        it 'creating a second one is different' do
          subject_1 = described_class.new_subject
          subject_2 = described_class.new_subject
          subject_1.should_not == subject_2
        end
      end

      describe '.new_id' do
        it 'creates a new (random) id' do
          described_class.new_id.should match(id_valid_regexp)
        end

        it 'creating a second one is different' do
          id_1 = described_class.new_id
          id_2 = described_class.new_id
          id_1.should_not == id_2
        end
      end

      describe '.from_string_values' do
        it 'reads the values correctly (round trip test)' do
          fact = described_class.from_string_values(string_values)
          fact.string_values.should == string_values
        end

        it 'calls validate_string_hash if options[:validate]' do
          described_class.should_receive(:validate_string_hash)
          described_class.from_string_values(string_values, validate: true)
        end

        it 'does not call validate_string_hash if not options[:validate]' do
          described_class.should_not_receive(:validate_string_hash)
          described_class.from_string_values(string_values)
        end
      end

      describe 'validation of the string_hash' do

        def with_validation(string_values)
          described_class.from_string_values(string_values, :validate => true)
        end

        describe 'does not raise exception' do
          it 'for unmodified string_values' do
            with_validation(string_values)
          end

          it 'for a nil context_subject (for contexts)' do
            string_values[2] = nil
            with_validation(string_values)
          end

          it 'for an empty context_subject (for contexts)' do
            string_values[2] = ''
            with_validation(string_values)
          end
        end

        describe 'does raise exception' do
          it 'for invalid id' do
            string_values[0] = 'foo'
            lambda{ with_validation(string_values) }.should raise_error(FactError)
          end

          it 'for invalid time_stamp' do
            string_values[1] = 'foo'
            lambda{ with_validation(string_values) }.should raise_error(FactError)
          end

          it 'for invalid context_subject' do
            string_values[2] = 'foo'
            lambda{ with_validation(string_values) }.should raise_error(FactError)
          end

          it 'for invalid subject' do
            string_values[3] = 'foo'
            lambda{ with_validation(string_values) }.should raise_error(FactError)
          end

          it 'for invalid predicate' do
            string_values[4] = ''
            lambda{ with_validation(string_values) }.should raise_error(FactError)
          end

          it 'for invalid object' do
            string_values[5] = ''
            lambda{ with_validation(string_values) }.should raise_error(FactError)
          end
        end
      end
    end
  end
end
