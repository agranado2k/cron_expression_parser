# frozen_string_literal: true

module CronExpressionParser
  # Class that manage the command execution
  class Main
    def initialize(parser:, formatter:, io:)
      @parser = parser
      @formatter = formatter
      @io = io
    end

    def exec(input)
      parsed_str = @parser.parse(input)
      formatted_output = @formatter.table(parsed_str)
      @io.print(formatted_output)
    rescue ValidationError => e
      @io.print("Validation Error: #{e.message}")
    end
  end
end
