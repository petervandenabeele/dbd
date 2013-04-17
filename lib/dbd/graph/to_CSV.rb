module Dbd
  module Graph
    module ToCSV

      def to_CSV
        self.map do |e|
          e.map do
            "\"abc-def-ghi\",\"blah foo bar\",\"2013-05-01 13:36:45.456893045\""
          end
        end.flatten.join("\n").encode("utf-8") + "\n"
      end

    end
  end
end
