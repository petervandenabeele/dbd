require 'spec_helper'

module Dbd
  describe Fact do

    let(:provenance_subject) { ProvenanceFact.new_subject }
    let(:subject) { described_class.new_subject }
    let(:fact_1) { TestFactories::Fact.fact_1(provenance_subject) }
    let(:fact_2_with_subject) { TestFactories::Fact.fact_2_with_subject(provenance_subject) }
    let(:fact_with_newline) { TestFactories::Fact.fact_with_newline(provenance_subject) }
    let(:full_fact) { TestFactories::Fact.full_fact }
    let(:factory) { described_class::Factory }

    describe '.factory' do
      it 'should return the factory for a Fact' do
        described_class.factory.should == factory
      end
    end

    describe 'time_stamp=' do
      it 'checks the type (too easy to try to give a Time arg)' do
        lambda{ fact_1.time_stamp = Time.now }.should raise_error(ArgumentError)
      end

      describe 'set_once' do

        let(:time_stamp_now) { TimeStamp.new }

        it 'can be set when nil' do
          fact_1.time_stamp = time_stamp_now
          fact_1.time_stamp.should == time_stamp_now
        end

        describe 'setting it two times' do
          it 'with the value succeeds' do
            fact_1.time_stamp = time_stamp_now
            fact_1.time_stamp = time_stamp_now
          end

          it 'with a different value raises a SetOnceError' do
            fact_1.time_stamp = time_stamp_now
            lambda{ fact_1.time_stamp = (time_stamp_now+1) }.should raise_error(RubyPeterV::SetOnceError)
          end
        end
      end
    end

    describe 'short' do
      it 'for a base fact shows provenance, subject, predicate, object' do
        fact_1.subject = subject
        fact_1.time_stamp = TimeStamp.new
        fact_1.short.should match(/^[0-9a-f]{8} : [0-9a-f]{8} : http:\/\/example\.org\/test\/ : Gandhi$/)
      end

      it 'for a fact with a newline replaces it with a underscore' do
        fact_with_newline.subject = subject
        fact_with_newline.short.should match(/^[0-9a-f]{8} : [0-9a-f]{8} : http:\/\/example\.org\/test\/ : A long story_really.$/)
      end
    end

    describe 'errors' do
      it 'the factory has no errors' do
        fact_2_with_subject.errors.should be_empty
      end

      describe 'without provenance_subject' do

        before(:each) do
          fact_2_with_subject.stub(:provenance_subject).and_return(nil)
        end

        it 'errors returns an array with 1 error message' do
          fact_2_with_subject.errors.single.should match(/Provenance subject is missing/)
        end
      end

      describe 'without subject' do

        before(:each) do
          fact_2_with_subject.stub(:subject).and_return(nil)
        end

        it 'errors returns an array with an errorm message' do
          fact_2_with_subject.errors.single.should match(/Subject is missing/)
        end
      end
    end

    describe 'attributes' do
      it 'there are 6 attributes' do
        described_class.attributes.size.should == 6
      end

      it 'first attribute is :id' do
        described_class.attributes.first.should == :id
      end
    end

    describe 'values' do
      it 'there are 6 values' do
        full_fact.values.size.should == 6
      end

      it 'the second element (time_stamp) is a TimeStamp' do
        full_fact.values[1].should be_a(TimeStamp)
      end
    end

    describe 'string_values' do
      it 'there are 6 string_values' do
        full_fact.string_values.size.should == 6
      end

      it 'the second element (time_stamp) is a String' do
        full_fact.string_values[1].should be_a(String)
      end
    end

    describe 'provenance_fact?' do
      it 'is false for a base fact or derived from it that is not a ProvenanceFact ' do
        fact_1.provenance_fact?.should be_false
      end
    end

    describe 'equivalent?' do

      # no let, since we want a fresh copy on each invocation
      def string_values
        TestFactories::Fact.string_values
      end

      let(:ref) { factory.from_string_values(string_values) }

      it 'is true for facts with same values' do
        other = factory.from_string_values(string_values)
        other.should be_equivalent(ref)
      end

      it 'is false for each of the entries largely different' do
        (0...string_values.size).each do |index|
          string_values_1_modified = string_values.dup.tap { |_string_values|
            _string_values[index][3] = '4' # different and valid for all cases
          }
          other = factory.from_string_values(string_values_1_modified)
          other.should_not be_equivalent(ref)
        end
      end

      it 'is true when the time_stamp is 500 ns larger' do
        string_values_time_modified = string_values.dup.tap { |_string_values|
          _string_values[1] = '2013-06-17 21:55:09.967653513 UTC'
        }
        other = factory.from_string_values(string_values_time_modified)
        other.should be_equivalent(ref)
      end
    end
  end
end
