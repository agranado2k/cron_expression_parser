# frozen_string_literal: true

module CronExpressionParser
  class Main
    def initialize(io:)
      @io = io
    end

    def exec(input)
      @io.print(input)
    end
  end
end
