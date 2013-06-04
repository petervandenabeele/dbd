require 'spec_helper'

module Dbd
  describe TimeStamp do
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
 end
end
