require 'spec_helper'

module Dbd
  module Helpers
    describe UUID do
      describe '.valid_regex' do
        it 'matches correct uuid' do
          '12345678-abcd-4567-89ab-0123456789ab'.should match(UUID.valid_regexp)
        end

        it 'does not match incorrect uuid' do
          '012345678-abcd-4567-89ab-0123456789ab'.should_not match(UUID.valid_regexp)
        end
      end

      it '.new creates a new random UUID' do
        described_class.new.to_s.should match(UUID.valid_regexp)
      end

      it '.new creates a new random UUID with UTF-8 encoding' do
        described_class.new.to_s.encoding.should == Encoding::UTF_8
      end
    end
  end
end
