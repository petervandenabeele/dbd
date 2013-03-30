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

      end
    end
  end
end
