require 'spec_helper'

module Dbd
  module Repo
    module Neo4j
      describe Base do
        it ".new works" do
          subject # does_not raise_error
        end

        it "has the Neography class" do
          ::Neography
        end

        it "can insert a node" do
          subject.create_node("age" => 31, "name" => "Max")
        end

        it "can create a relationship" do
          max = subject.create_node("age" => 31, "name" => "Max")
          roel = subject.create_node("age" => 33, "name" => "Roel")
          subject.create_relationship("co-founders", max, roel)
        end

        describe "play with a minimal graph" do

          before(:each) do
            max = subject.create_node("age" => 31, "name" => "Max")
            roel = subject.create_node("age" => 33, "name" => "Roel")
            subject.create_relationship("co-founders", max, roel)
          end

          it "can get the root node" do
            root = subject.get_root
          end

          it "can get all nodes with a query" do
            result = subject.execute_query("start n=node(*) return n")
            result["data"].last.single["data"]["name"].should == "Roel"
          end

          it "can get the last 5 nodes with load_node" do
            result = subject.execute_query("start n=node(*) return n")
            node_uris = result["data"].last(5).map{|n| n.single["self"]}
            nodes = node_uris.map do |uri|
              subject.load_node(uri)
            end
            nodes.last.should be_a(Neography::Node)
          end

          describe "a loaded node" do

            let(:node) do
              result = subject.execute_query("start n=node(*) return n")
              uri = result["data"].last.single["self"]
              subject.load_node(uri)
            end

            it "has age 33" do
              node.age.should == 33
            end

            it "has many methods" do
              puts node.methods - Object.methods
            end

          end
        end
      end
    end
  end
end
