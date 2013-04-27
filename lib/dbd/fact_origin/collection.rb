module Dbd
  module FactOrigin

    class OverwriteKeyError < StandardError
    end

    class Collection

      include Helpers::HashCollection

      def is_ordered?
        false
      end

      def <<(fact_origin)
        raise OverwriteKeyError if self[fact_origin.id]
        super
      end

    end
  end
end
