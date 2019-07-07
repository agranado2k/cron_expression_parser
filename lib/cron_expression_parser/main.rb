# frozen_string_literal: true

module CronExpressionParser
  class Main
    def initialize(io:)
      @io = io
    end

    def exec(input)
      parsed_str = @parser.parse(input)
      formatted_output = @format_output.table(parsed_str)
      @io.print(formatted_output)
    end
  end
end
