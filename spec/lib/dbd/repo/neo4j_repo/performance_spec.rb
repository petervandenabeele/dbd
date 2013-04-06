require 'spec_helper'

module Dbd
  module Repo
    module Neo4jRepo
      describe Base do

        it "can insert a node" do
          subject.create_node("age" => 31, "name" => "Max")
        end

        it "can insert maaaaany nodes and find them in the index" do

#          MANY = 1000
#          (1..MANY).each do |age|
#            name = "Pax_#{age}"
#            max = subject.create_node("age" => age, "name" => name)
#            subject.add_node_to_index("name_index", "name", name, max)
#          end

          Knodes = 75000
          MANY = 100
          OFFSET = 125010

          (OFFSET...(OFFSET+Knodes)).each do |knode|
            puts knode
            array = []
            (0...MANY).each do |partial_age|
              age = (knode * MANY) + partial_age
              name = "Sax_#{age}"
              comment = "Adolphe Sax_#{age} with a lot more text to it " + "A"*partial_age + " " + "B"*2*partial_age
              array << [:create_node, {"age" => age, "name" => name, "comment" => comment}]
              array << [:add_node_to_index, "name_index", "name", name, "{#{3*partial_age}}"]
              if partial_age > 0
                array << [:create_relationship, "friends", "{#{3*(partial_age-1)}}", "{#{3*partial_age}}", {:since => "ever"}]
              else
                array << [:create_node, {"age" => age, "name" => "foo"}]
              end
            end

            subject.batch(*array)
          end

          result = subject.get_node_index("name_index", "name", "Sax_9700")
          result.should_not be_nil
          result.size.should > 0
        end

      end
    end
  end
end
