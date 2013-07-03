require 'spec_helper'

module Dbd
  describe TimeStamp do
    describe '.new' do

      let(:time) { Time.now.utc }

      let(:time_string) { TestFactories::TimeStamp.fixed_time_string }

      before(:each) do
        time
        Time.stub(:now).and_return(time)
      end

      it 'creates a new (random) time_stamp' do
        subject # should_not raise_error
      end

      it 'with :time option given a Time object, sets that to time' do
        near_future = time + 100
        time_stamp = described_class.new(time: near_future)
        time_stamp.time.should == near_future
      end

      it 'with :time option given a String object, sets that to time' do
        time_stamp = described_class.new(time: time_string)
        time_stamp.to_s.should == time_string
      end

      it 'with :larger_than, sets a time that is strictly and slightly larger than this' do
        larger_than = described_class.new(time: time + Rational('500/1000_000')) # 0.5 ms
        time_stamp = described_class.new(larger_than: larger_than)
        time_stamp.time.should > larger_than.time
        (time_stamp.time - larger_than.time).should < Rational('1/1000_000') # 1 us
      end

      it 'without :larger_than adds some random time to the generated time' do
        time_stamp = described_class.new
        time_stamp.time.should > time
        (time_stamp.time - time).should < Rational('1/1000_000') # 1 us
      end
    end
  end
end
