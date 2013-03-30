module Dbd
  module Repo
    module Neo4jRepo
      class Performance

        def initialize
          @base = Dbd::Repo::Neo4jRepo::Base.new
        end

      end
    end
  end
end
