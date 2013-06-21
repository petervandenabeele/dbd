require 'spec_helper'

module Dbd
  describe Graph do

    def round_tripped_graph(graph)
      Graph.from_CSV(StringIO.new(graph.to_CSV))
    end

    def validate_round_trip(graph)
      graph_from_CSV = round_tripped_graph(graph)
      # temporarily use to_csv as the "identity function" for Graph
      # TODO define a proper Equality for Graph and Fact
      graph_from_CSV.to_CSV.should == graph.to_CSV
    end

    describe ".from_CSV reads back a csv exported graph correctly" do

      describe "for a graph with only provenance_facts" do

        let(:graph) { Factories::Graph.only_provenance }

        it "round_trip validates" do
          validate_round_trip(graph)
        end

        it "for a provenance_fact, the provenance_subject must be equal (nil)" do
          graph_from_CSV = round_tripped_graph(graph)
          provenance_fact = graph_from_CSV.first
          provenance_fact.provenance_subject.should be_nil
        end
      end

      describe "for a graph with facts and provenance_facts" do

        let(:graph) { Factories::Graph.full }

        it "round_trip validates" do
          validate_round_trip(graph)
        end

        it "the short export of a graph is correct after a round trip" do
          imported_graph = Dbd::Graph.from_CSV(graph.to_CSV)
          imported_graph.map(&:short).should == (graph.map(&:short))
        end
      end
    end
  end
end
