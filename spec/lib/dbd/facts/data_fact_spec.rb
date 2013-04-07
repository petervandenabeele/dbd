require 'spec_helper'

module Dbd
  module Facts
    describe DataFact do
      it "class exist" do
        described_class # should not raise error
      end

      describe "create a data_fact" do
        describe "with a string object type" do
          it "new does not raise exception" do
            subject # should_not raise_exception
          end

          it "has a unique id (UUID)" do
            subject.id.should be_a(Helpers::TempUUID)
          end
        end
      end
    end
  end
end
