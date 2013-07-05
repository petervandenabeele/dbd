require 'spec_helper'

module Dbd
  describe TimeStamp do
    describe '.new' do

      let(:base_time) { Time.utc(2013,5,18,12,0,0)}

      let(:time_string) { TestFactories::TimeStamp.fixed_time_string }

      before(:each) do
        Time.stub(:now).and_return(base_time)
      end

      it 'creates a new (random) time_stamp' do
        subject # should_not raise_error
      end

      it 'with :time option given a Time object, sets that to time' do
        near_future = base_time + 100
        time_stamp = described_class.new(time: near_future)
        time_stamp.time.should == near_future
      end

      it 'with :time option given a String object, sets that to time' do
        time_stamp = described_class.new(time: time_string)
        time_stamp.to_s.should == time_string
      end

      it 'with :larger_than, sets a time that is strictly and slightly larger than this' do
        larger_than = described_class.new(time: base_time + Rational('500/1000_000')) # 0.5 ms
        time_stamp = described_class.new(larger_than: larger_than)
        time_stamp.time.should > larger_than.time
        (time_stamp.time - larger_than.time).should < Rational('1/1000_000') # 1 us
      end

      it 'without :larger_than adds some random time to the generated time' do
        time_stamp = described_class.new
        time_stamp.time.should > base_time
        (time_stamp.time - base_time).should < Rational('1/1000_000') # 1 us
      end

      it 'using "minimum_time_offset" as a diff for new is always causing strictly larger time_stamp' do
        time_stamp = described_class.new(time: base_time)
        minimum_time_offset = nil
        time_stamp.instance_eval do
          # read the private variable.
          # The public API methods "could" be used
          # (and did expose the problem eventually), but
          # only with a very low probability due to the
          # random offset (using a minimum offset,
          # triggers the issue with much less iterations).
          minimum_time_offset = minimum_time_offset()
        end
        (1..100).each do |i|
          higher = described_class.new(time: base_time + i * minimum_time_offset)
          higher.should > time_stamp
          time_stamp = higher
        end
      end

      it 'with :time option given a String object, sets that to time for many values' do
        (0...100).each do |i|
          time_string = "2013-07-04 18:48:07.26300#{i.to_s.rjust(4,'0')} UTC"
          time_stamp = described_class.new(time: time_string)
          time_stamp.to_s.should == time_string
        end
      end
    end
  end
end
