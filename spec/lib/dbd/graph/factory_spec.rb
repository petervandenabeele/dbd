require 'spec_helper'

module Dbd
  describe Graph do
    describe "factory" do
      describe "with only provenance facts" do

        let(:only_provenance) { Factories::Graph.only_provenance }

        it "is a Graph" do
          only_provenance.should be_a(Graph)
        end

        it "has some facts" do
          only_provenance.size.should >= 2
        end
      end
    end
  end
end
