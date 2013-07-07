require 'spec_helper'

module Dbd
  class Fact
    describe Factory do

      let (:string_values) { TestFactories::Fact.string_values }

      describe 'from_string_values' do
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

          it 'for a nil provenance_subject (for provenance_facts)' do
            string_values[2] = nil
            with_validation(string_values)
          end

          it 'for an empty provenance_subject (for provenance_facts)' do
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

          it 'for invalid provenance_subject' do
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
