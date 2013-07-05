require 'spec_helper'

module Dbd
  class Fact
    describe Subject do
      it ".valid_regexp has a regexp for the to_s" do
        described_class.valid_regexp.should == Helpers::UUID.valid_regexp
      end

      it ".new_subject" do
        described_class.new_subject.should match(described_class.valid_regexp)
      end
    end
  end
end
