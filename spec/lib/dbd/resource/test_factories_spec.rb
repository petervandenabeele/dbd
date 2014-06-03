require 'spec_helper'

module TestFactories
  describe Resource do

    let(:context_subject) { TestFactories::ContextFact.new_subject }

    describe "TestFactories::Resource" do
      it ".empty works" do
        resource = described_class.empty
        expect(resource.context_subject).to be_nil
      end

      describe ".facts_resource" do
        it "works with explicit context_subject" do
          resource = described_class.facts_resource(context_subject)
          resource.context_subject.should == context_subject
        end

        it "works without explicit context_subject" do
          resource = described_class.facts_resource()
          resource.context_subject.should be_nil
        end
      end
    end
  end
end
