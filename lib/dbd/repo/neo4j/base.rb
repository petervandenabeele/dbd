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

      end
    end
  end
end
