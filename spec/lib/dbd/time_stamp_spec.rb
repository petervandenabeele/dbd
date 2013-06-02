require 'spec_helper'

module Dbd
  describe TimeStamp do
    describe ".new" do

      let(:time) { Time.now.utc }

      before(:each) do
        time
        Time.stub(:now).and_return(time)
      end

      it "creates a new (random) time_stamp" do
        subject # should_not raise_error
      end

      it "with :time option, sets that to time" do
        near_future = time + 100
        time_stamp = described_class.new(time: near_future)
        time_stamp.time.should == near_future
      end

      it "with :larger_than, sets a time that is strictly and slightly larger than this" do
        larger_than = described_class.new(time: time + Rational('500/1000_000')) # 0.5 ms
        time_stamp = described_class.new(larger_than: larger_than)
        time_stamp.time.should > larger_than.time
        (time_stamp.time - larger_than.time).should < Rational('1/1000_000') # 1 us
      end

      it "without :larger_than adds some random time to the generated time" do
        time_stamp = described_class.new
        time_stamp.time.should > time
        (time_stamp.time - time).should < Rational('1/1000_000') # 1 us
      end
    end

    describe ".time_format_regexp" do
      it "matches an example string" do
        a_time_stamp = "2013-05-16 23:52:38.123456789 UTC"
        a_time_stamp.should match(described_class.to_s_regexp)
      end
    end

    describe "#time to allow comparison" do
      it "responds with a time" do
        described_class.new.time.should be_a(Time)
      end
    end

    describe "#to_s" do
      it "returns a Time format string" do
        subject.to_s.should match(described_class.to_s_regexp)
      end
    end

    let(:time_stamp_0) { described_class.new(time: Time.new(2013,5,18,12,0,0)) }
    let(:time_stamp_1) { described_class.new(time: Time.new(2013,5,18,12,0,0)) }
    let(:time_stamp_2) { described_class.new(time: Time.new(2013,5,18,12,0,1)) }

    describe "==" do
      it "should be ==" do
        time_stamp_0.should == time_stamp_1
      end

      it "hash should also be equal" do
        time_stamp_0.hash.should == time_stamp_1.hash
      end
    end

    describe ">" do
      it "is true if time_stamp is really larger" do
        time_stamp_2.should > time_stamp_1
      end
    end

    describe "<" do
      it "is true if time_stamp is really smaller" do
        time_stamp_1.should < time_stamp_2
      end
    end

    describe ">=" do
      it "is true if time_stamp_2 is really larger" do
        time_stamp_2.should >= time_stamp_1
      end
    end

    describe "<=" do
      it "is true if time_stamp_1 is really smaller" do
        time_stamp_1.should <= time_stamp_2
      end
    end

    describe "+" do
      it "returns a larger time_stamp" do
        (subject + 1).should > subject
      end

      it "sees a difference of 1 nanosecond" do
        (subject + Rational('1/1000_000_000')).should > subject
      end
    end

    describe "-" do
      it "returns the time difference" do
        ((subject + 1) - subject).should == 1
      end

      it "sees a difference of 1 nanosecond" do
        ((subject + Rational('1/1000_000_000')) - subject).should == Rational('1/1_000_000_000')
      end
    end
  end
end
