require 'spec_helper'

module Dbd
  class Fact
    describe Subject do
      describe "Factory" do

        let(:fixed_subject) { Factories::Fact::Subject.fixed_subject }
        let(:fixed_provenance_subject) { Factories::Fact::Subject.fixed_provenance_subject }

        describe "fixed_subject" do
          it "is an Fact::Subject" do
            fixed_subject.should be_a(described_class)
          end

          it "fixed_subject is exactly this fixed id" do
            fixed_subject.to_s.should == "2e9fbc87-2e94-47e9-a8fd-121cc4bc3e8f"
          end
        end

        describe "fixed_provenance_subject" do
          it "is an Fact::Subject" do
            fixed_provenance_subject.should be_a(described_class)
          end

          it "fixed_provenance_subject is exactly this fixed id" do
            fixed_provenance_subject.to_s.should == "40fab407-9b04-4a51-9a52-d978abfcbb1f"
          end
        end
      end
    end
  end
end