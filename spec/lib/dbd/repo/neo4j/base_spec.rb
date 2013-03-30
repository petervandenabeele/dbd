require 'spec_helper'

module Dbd
  module Repo
    module Neo4j
      describe Base do
        it ".new works" do
          subject # does_not raise_error
        end
      end
    end
  end
end
