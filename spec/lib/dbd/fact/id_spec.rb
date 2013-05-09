require 'spec_helper'

module Dbd
  class Fact
    describe ID do
      it ".new creates an ID" do
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
