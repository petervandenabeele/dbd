require 'spec_helper'

module Dbd
  describe TimeStamp do

    let(:a_time_stamp) { '2013-05-16 23:52:38.123456789 UTC' }

    describe '.time_format_regexp' do
      it 'matches an example string' do
        a_time_stamp.should match(described_class.to_s_regexp)
      end

      it 'does not match an incorrect string' do
        ('0' + a_time_stamp).should_not match(described_class.to_s_regexp)
      end
    end

    describe '#time to allow comparison' do
      it 'responds with a time' do
        described_class.new.time.should be_a(Time)
      end
    end

    describe '#to_s' do
      it 'returns a Time format string' do
        subject.to_s.should match(described_class.to_s_regexp)
      end
    end

    describe '.from_s' do
      it 'returns a TimeStamp' do
        described_class.new(time: a_time_stamp).should be_a(described_class)
      end

      it 'round trips with to_s' do
        time_stamp = described_class.new(time: a_time_stamp)
        time_stamp.to_s.should == a_time_stamp
      end

      it 'raises ArgumentError is time_zone is not UTC' do
        time_CET = a_time_stamp.sub(/UTC/, 'CET')
        lambda{ described_class.new(time: time_CET) }.should raise_error ArgumentError
      end
    end
  end
end
