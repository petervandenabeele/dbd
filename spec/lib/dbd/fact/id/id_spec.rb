require 'spec_helper'

module Dbd
  class Fact
    describe ID do
      it ".regexp has a regexp for the to_s" do
        described_class.regexp.should == Helpers::UUID.regexp
      end

      it ".new_id" do
        described_class.new_id.should match(described_class.regexp)
      end
    end
  end
end
