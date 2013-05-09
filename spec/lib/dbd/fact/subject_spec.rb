require 'spec_helper'

module Dbd
  module Fact
    describe Subject do
      it ".new creates a Subject" do
        subject.should be_a(described_class)
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
