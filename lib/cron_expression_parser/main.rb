# frozen_string_literal: true

module CronExpressionParser
  # Class that manage the command execution
  class Main
    def initialize(parser:, io:)
      @parser = parser
      @io = io
    end

    def exec(input)
      parsed_str = @parser.parse(input)
      formatted_output = @format_output.table(parsed_str)
      @io.print(formatted_output)
    end
  end
end
