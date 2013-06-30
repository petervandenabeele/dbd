require 'spec_helper'

module Dbd
  module Helpers
    describe UUID do
      it ".regex" do
        '12345678-abcd-4567-89ab-0123456789ab'.should match(UUID.regexp)
      end

      it ".new creates a new random UUID" do
        described_class.new.to_s.should match(UUID.regexp)
      end

      it ".new creates a new random UUID with UTF-8 encoding" do
        described_class.new.to_s.encoding.should == Encoding::UTF_8
      end
    end
  end
end
