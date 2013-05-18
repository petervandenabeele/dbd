require 'spec_helper'

module Dbd
  describe TimeStamp do
    describe ".new" do
      it "creates a new (random) time_stamp" do
        subject # should_not raise_error
      end
    end

    describe ".time_format_regexp" do
      it "matches an example string" do
        a_time_stamp = "2013-05-16 23:52:38.123456789 UTC"
        a_time_stamp.should match(described_class.to_s_regexp)
      end
    end

    describe "#to_s" do
      it "returns a Time format string" do
        subject.to_s.should match(described_class.to_s_regexp)
      end
    end
  end
end

=begin
      it "sees a difference of 2 nanoseconds" do
        time_now = Time.now
        fact_1.time_stamp = time_now + Rational('2/1000_000_000')
        fact_1.time_stamp.should > time_now
      end
=end
