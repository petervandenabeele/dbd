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

      describe "full" do

        let(:full) { Factories::Graph.full }

        it "is a Graph" do
          full.should be_a(Graph)
        end

        it "full has many facts" do
          full.size.should >= 4
        end
      end
    end
  end
end
