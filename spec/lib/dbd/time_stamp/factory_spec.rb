require 'spec_helper'

module Dbd
  describe TimeStamp do

    let(:fixed_time_stamp) { Factories::TimeStamp.fixed_time_stamp }

    describe "factory works" do
      it "is a TimeStamp" do
        fixed_time_stamp.should be_a(TimeStamp)
      end

      it "has an exact time" do
        fixed_time_stamp.to_s.should == "2013-06-17 21:55:09.967653013 UTC"
      end
    end
  end
end
