require 'spec_helper'

module Dbd
  class Fact
    describe ID do
      describe ".new" do
        it "creates an ID with a random uuid" do
          subject.should be_a(described_class)
        end

        it "optionally takes an options hash with :uuid key" do
          uuid = "825e44d5-af33-4858-8047-549bd813daa8"
          id = described_class.new(uuid: uuid)
          id.to_s.should == uuid
        end
      end

      it "#to_s is a UUID string" do
        subject.to_s.should match(Helpers::UUID.regexp)
      end

      it ".regexp has a regexp for the to_s" do
        described_class.regexp.should == Helpers::UUID.regexp
      end

      it "has equality on uuid" do
        uuid = "825e44d5-af33-4858-8047-549bd813daa8"
        id_1 = described_class.new(uuid: uuid)
        id_2 = described_class.new(uuid: uuid)
        id_1.should == id_2
      end
    end
  end
end
