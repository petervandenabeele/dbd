module Dbd
  module FactOrigin
    class FactOrigin

      STRING_ATTRIBUTES = [
        :context,
        :original_source,
        :created_by,
        :entered_by]

      DATE_ATTRIBUTES = [
        :created_at,
        :entered_at,
        :valid_from,
        :valid_until]

      def self.attributes
        [:id] + STRING_ATTRIBUTES + DATE_ATTRIBUTES
      end

      attributes.each do |attribute|
        attr_reader attribute
      end

      def initialize(options = {})
        @id = UUIDTools::UUID.random_create
        options.each do |k, v|
          self.instance_variable_set(:"@#{k}", v)
        end
      end

      def values
        self.class.attributes.map{|attribute| self.send(attribute)}
      end

    end
  end
end
