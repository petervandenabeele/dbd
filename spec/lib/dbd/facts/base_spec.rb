require 'spec_helper'

module Dbd
  module Facts
    describe Base do
      it "module exists" do
        described_class # should not raise error
      end

      it "The RDF module is loaded" do
        RDF # should not raise error
      end

      describe "play with a graph" do

        let(:graph) {RDF::Graph.new << [:hi, RDF::DC.title, "Hello, world!"]}

        it "Create a graph" do
          graph # should_not raise_error
        end

        it "writing data" do
          graph.dump(:ntriples).chomp.should ==
            '_:hi <http://purl.org/dc/terms/title> "Hello, world!" .'
        end

        it "Reading N-triples" do
          n_triples_string =
            '<http://example.com/test#1> ' +
            '<http://www.w3.org/2000/01/rdf-schema#label> ' +
            '"test 1" .'
          RDF::Reader.for(:ntriples).new(n_triples_string) do |reader|
            reader.each_statement do |statement|
               statement.to_ntriples.chomp.should == n_triples_string
            end
          end
        end
      end
    end
  end
end
