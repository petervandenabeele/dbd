require 'spec_helper'

module Dbd
  class Fact
    describe ID do
      describe "Factory" do

        let(:fixed_id) { Factories::Fact::ID.fixed_id }

        it "fixed_id is an Fact::ID" do
          fixed_id.should be_a(described_class)
        end

        it "fixed_id is exactly this fixed id" do
          fixed_id.to_s.should == "825e44d5-af33-4858-8047-549bd813daa8"
        end
      end
    end
  end
end
