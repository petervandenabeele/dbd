require 'spec_helper'

module Dbd
  class Fact
    describe Subject do
      describe ".new" do
        it "creates a Subject" do
          subject.should be_a(described_class)
        end

        it "takes an optional :uuid option argument" do
          uuid = "fe75eae3-cb14-4495-b726-7ecba8798b6d"
          subject = described_class.new(uuid: uuid)
          subject.to_s.should == uuid
        end
      end

      it "#to_s is a UUID string" do
        subject.to_s.should match(Helpers::UUID.regexp)
      end

      it ".regexp has a regexp for the to_s" do
        described_class.regexp.should == Helpers::UUID.regexp
      end
    end
  end
end
