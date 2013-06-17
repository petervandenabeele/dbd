require 'spec_helper'

module Dbd
  describe Graph do

    def new_subject
      Fact.new_subject
    end

    def validate_round_trip(graph)
      graph_from_csv = Graph.from_CSV(StringIO.new(graph.to_CSV))

      # use to_csv as the "identity function" for Graph
      graph.to_CSV.should == graph_from_csv.to_CSV
    end

    describe "#from_CSV reads back a csv exported graph correctly" do
      it "is correct for a graph with only provenance_facts" do
        graph = Factories::Graph.only_provenance
        validate_round_trip(graph)
      end

      it "is correct for a graph with facts and provenance_facts" do
        graph = Factories::Graph.only_provenance
        validate_round_trip(graph)
      end
    end
  end
end
