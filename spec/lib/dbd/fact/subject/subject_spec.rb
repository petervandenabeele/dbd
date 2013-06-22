require 'spec_helper'

module Dbd
  class Fact
    describe Subject do
      it ".regexp has a regexp for the to_s" do
        described_class.regexp.should == Helpers::UUID.regexp
      end

      it ".new_subject" do
        described_class.new_subject.should match(described_class.regexp)
      end
    end
  end
end
