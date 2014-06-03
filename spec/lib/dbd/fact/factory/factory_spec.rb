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

        it 'converts a \n (backslash n, no newline) to newline' do
          fact = described_class.from_string_values(string_values)
          fact.object.should match(/\n/) # a newline
        end

        it 'converts a \\\\ (double backslash) into a single backslash' do
          fact = described_class.from_string_values(string_values)
          fact.object.should match(%r{[^\\]\\n}) # a backslash + newline
        end

        it 'calls validate_string_hash if options[:validate]' do
          expect(described_class).to receive(:validate_string_hash)
          described_class.from_string_values(string_values, validate: true)
        end

        it 'does not call validate_string_hash if not options[:validate]' do
          expect(described_class).to_not receive(:validate_string_hash)
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

          it 'for an empty context_subject (for context_facts)' do
            string_values[2] = ''
            with_validation(string_values)
          end
        end

        describe 'does raise exception' do

          def should_raise_fact_error
            lambda{ with_validation(string_values) }.should raise_error(FactError)
          end

          def should_raise_object_type_error
            lambda{ with_validation(string_values) }.should raise_error(ObjectTypeError)
          end

          it 'for invalid id' do
            string_values[0] = 'foo'
            should_raise_fact_error
          end

          it 'for invalid time_stamp' do
            string_values[1] = 'foo'
            should_raise_fact_error
          end

          it 'for invalid context_subject' do
            string_values[2] = 'foo'
            should_raise_fact_error
          end

          it 'for invalid subject' do
            string_values[3] = 'foo'
            should_raise_fact_error
          end

          it 'for invalid predicate' do
            string_values[4] = ''
            lambda{ with_validation(string_values) }.should raise_error(PredicateError)
          end

          it 'for invalid object_type' do
            string_values[5] = 'sb'
            should_raise_object_type_error
          end

          it 'for other invalid object_type' do
            string_values[5] = 'int'
            should_raise_object_type_error
          end

          it 'for invalid object' do
            string_values[6] = ''
            lambda{ with_validation(string_values) }.should raise_error(ObjectError)
          end
        end
      end
    end
  end
end
