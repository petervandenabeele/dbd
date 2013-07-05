require 'spec_helper'

module Dbd
  class Fact
    describe ID do
      it '.valid_regexp has a regexp for the to_s' do
        described_class.valid_regexp.should == Helpers::UUID.valid_regexp
      end

      it '.new_id' do
        described_class.new_id.should match(described_class.valid_regexp)
      end
    end
  end
end
