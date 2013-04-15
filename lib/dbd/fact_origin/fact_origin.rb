module Dbd
  module FactOrigin
    class FactOrigin

      STRING_PROPERTIES = [
        :context,
        :original_source,
        :created_by,
        :entered_by]

      DATE_PROPERTIES = [
        :created_at,
        :entered_at,
        :valid_from,
        :valid_until]

      attr_reader :id
      (STRING_PROPERTIES + DATE_PROPERTIES).each do |property|
        attr_reader property
      end

      def initialize(options = {})
        @id = UUIDTools::UUID.random_create
        options.each do |k, v|
          self.instance_variable_set(:"@#{k}", v)
        end
      end

    end
  end
end
