# encoding=utf-8
require 'spec_helper'

module Dbd
  describe Graph do

    def round_tripped_graph(graph)
      described_class.new.from_CSV(StringIO.new(graph.to_CSV))
    end

    def validate_round_trip(graph)
      graph_from_CSV = round_tripped_graph(graph)
      # temporarily use to_csv as the 'identity function' for Graph
      # TODO define a proper Equality for Graph and Fact
      graph_from_CSV.to_CSV.should == graph.to_CSV
    end

    describe '#from_CSV reads back a csv exported graph correctly' do
      describe 'for a graph with only context_facts' do

        let(:graph) { TestFactories::Graph.only_context }

        it 'round_trip validates' do
          validate_round_trip(graph)
        end

        it 'for a context_fact, the context_subject must be equal (nil)' do
          graph_from_CSV = round_tripped_graph(graph)
          context_fact = graph_from_CSV.first
          context_fact.context_subject.should be_nil
        end
      end

      describe 'for a graph with facts and context_facts' do

        let(:graph) { TestFactories::Graph.full }

        it 'round_trip validates' do
          validate_round_trip(graph)
        end

        it 'the short export of a graph is correct after a round trip' do
          imported_graph = described_class.new.from_CSV(graph.to_CSV)
          imported_graph.map(&:short).should == (graph.map(&:short))
        end
      end
    end

    describe '#from_CSV reads back _two_ csv exported graphs correctly' do
      describe 'for a graph with facts and context_facts' do

        let(:graph_context) { TestFactories::Graph.only_context }
        let(:graph_facts) { TestFactories::Graph.only_facts(graph_context.first.subject) }
        let(:graph_context_csv) { graph_context.to_CSV }
        let(:graph_facts_csv) { graph_facts.to_CSV }

        let(:graph_from_2_csv_s) do
          stream_1 = StringIO.new(graph_context_csv)
          stream_2 = StringIO.new(graph_facts_csv)
          graph = described_class.new
          graph.from_CSV(stream_1)
          graph.from_CSV(stream_2)
        end

        it 'round_trip validates' do
          # we do not have full graph equivalence yet
          graph_from_2_csv_s.first.should be_equivalent(graph_context.first)
          graph_from_2_csv_s.last.should be_equivalent(graph_facts.last)
        end

        it 'a string concat of 2 CSV files works to logically concat them' do
          graph_from_2_csv_s.to_CSV.should == (graph_context_csv + graph_facts_csv)
        end
      end
    end

    describe '#from_CSV reads special cases correctly' do

      let(:context_subject) { TestFactories::Fact::Subject.fixed_context_subject }
      let(:resource) { TestFactories::Resource.empty(context_subject) }
      let(:special_fact) { TestFactories::Fact.fact_with_special_chars(context_subject, resource.subject) }

      it 'as object' do
        resource << special_fact
        graph = described_class.new << resource
        csv = graph.to_CSV
        csv.should match(%r{A long story with a newline\nreally with a comma, a double quote "" and a non-ASCII char éà Über.})
        graph_from_CSV = described_class.new.from_CSV(csv)
        graph_from_CSV.first.should be_equivalent(graph.first)
      end
    end
  end
end
