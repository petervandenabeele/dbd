require 'spec_helper'

module Dbd
  describe TimeStamp do

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
