# frozen_string_literal: true

module CronExpressionParser
  # Class that manage the command execution
  class Formatter
    def table(input)
      <<~OUTPUT
        minute        #{format_line(input, :minute)}
        hour          #{format_line(input, :hour)}
        day of month  #{format_line(input, :day_of_month)}
        month         #{format_line(input, :month)}
        day of week   #{format_line(input, :day_of_week)}
        command       #{input[:command]}
      OUTPUT
    end

    private

    def format_line(input, type)
      input[type].join(' ')
    end
  end
end
