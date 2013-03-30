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
      end
    end
  end
end
