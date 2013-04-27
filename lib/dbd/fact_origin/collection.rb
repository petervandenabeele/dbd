module Dbd
  module FactOrigin

    class OverwriteIdError < StandardError
    end

    class Collection

      include Helpers::HashCollection

      def is_ordered?
        false
      end

      def <<(fact_origin)
        raise OverwriteIdError if self[fact_origin.id]
        super
      end

    end
  end
end
