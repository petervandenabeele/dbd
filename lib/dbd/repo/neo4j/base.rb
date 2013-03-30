module Dbd
  module Repo
    module Neo4j
      class Base

        def initialize
          @neo = Neography::Rest.new
        end

        def create_node(hash)
          @neo.create_node(hash)
        end

        def create_relationship(p, s, o)
          @neo.create_relationship(p, s, o)
        end

        def execute_query(query_string)
          @neo.execute_query(query_string)
        end

        def get_root
          @neo.get_root
        end

        def load_node(uri)
          Neography::Node.load(uri)
        end

      end
    end
  end
end
