module Dbd
  module Graph
    module ToCSV

      # Export a graph to a CSV
      #
      # @param (none)
      #
      # @return a comma separated CSV with double quoted strings
      #
      # @api public
      def to_CSV
        self.map do |e|
          e.map do
            "\"abc-def-ghi\",\"blah foo bar\",\"2013-05-01 13:36:45.456893045\""
          end
        end.flatten.join("\n").encode("utf-8") + "\n"
        # see rejected bug http://bugs.ruby-lang.org/issues/8289
      end

    end
  end
end
