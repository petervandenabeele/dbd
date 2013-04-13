module Dbd
  module FactOrigin

    class NotPresentError < StandardError
    end

    class Collection

      include Helpers::Collection

      def by_id(id)
        find{|e| e.id == id} or raise NotPresentError
      end

    end
  end
end
