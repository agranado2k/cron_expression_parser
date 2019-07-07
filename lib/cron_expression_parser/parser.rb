# frozen_string_literal: true

module CronExpressionParser
  POSITION = {
    minute: 0,
    hour: 1,
    day_of_month: 2,
    month: 3,
    day_of_week: 4
  }
  RANGES = {
    minute: [0, 59],
    hour: [0, 23],
    day_of_month: [1, 31],
    month: [1, 12],
    day_of_week: [1, 7]
  }

  # String parser
  class Parser
    def parse(str)
      {
        minute: parse_rule_for(str, :minute),
        hour: parse_rule_for(str, :hour),
        day_of_month: parse_rule_for(str, :day_of_month),
        month: parse_rule_for(str, :month),
        day_of_week: parse_rule_for(str, :day_of_week),
        command: '/usr/bin/find'
      }
    end

    private

      def parse_rule_for(str, time_unit)
        str_for(str, time_unit) == '*' ? all_range_for(time_unit): [0]
      end

      def str_for(str, time_unit)
        str.split(/\s+/)[POSITION[time_unit]]
      end

      def all_range_for(time_unit)
        ranges = RANGES[time_unit]
        (ranges[0]..ranges[1]).to_a
      end
  end
end
