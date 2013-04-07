module Factories
  module FactOrigin

    def self.me
      OpenStruct.new(:id => :fact_origin_id)
    end
  end
end
