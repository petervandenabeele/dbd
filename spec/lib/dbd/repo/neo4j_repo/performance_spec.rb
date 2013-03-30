require 'spec_helper'

module Dbd
  module Repo
    module Neo4jRepo
      describe Performance do
        it ".new works" do
          subject # does_not raise_error
        end
      end
    end
  end
end
