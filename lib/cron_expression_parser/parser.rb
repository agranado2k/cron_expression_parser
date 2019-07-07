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
      str = str.split(/\s+/)
      {
        minute: parse_rule_for(str, :minute),
        hour: parse_rule_for(str, :hour),
        day_of_month: parse_rule_for(str, :day_of_month),
        month: parse_rule_for(str, :month),
        day_of_week: parse_rule_for(str, :day_of_week),
        command: str.last
      }
    end

    private

      def parse_rule_for(str, time_unit)
        time_unit_str = str_for(str, time_unit)

        if full_range_rule?(time_unit_str)
          all_range_for(time_unit)
        elsif sub_range_rule?(time_unit_str)
          sub_range(time_unit_str)
        elsif by_interval_rule?(time_unit_str)
          interval_range(time_unit_str, time_unit)
        elsif explicity_range_rule?(time_unit_str)
          explicity_range(time_unit_str)
        else
          [time_unit_str.to_i]
        end
      end

      def str_for(str, time_unit)
        str[POSITION[time_unit]]
      end

      def all_range_for(time_unit)
        ranges = RANGES[time_unit]
        (ranges[0]..ranges[1]).to_a
      end

      def sub_range(str)
        edges = parse_range_edges(str)
        (edges[:start]..edges[:end]).to_a
      end

      def parse_range_edges(str)
        sub_str = str.split('-').map(&:to_i)
        {start: sub_str[0], end: sub_str[1]}
      end

      def interval_range(str, unit)
        r_start = RANGES[unit][0]
        r_end = RANGES[unit][1]
        range = [r_start]
        interval = str.match(/^\*\/(\d+)$/)[1].to_i

        while ((next_period = range.last + interval) <= r_end) do
          range.push next_period
        end

        range
      end

      def explicity_range(str)
        str.split(/,/).map(&:to_i)
      end

      def full_range_rule?(str)
        str.match /^\*$/
      end

      def sub_range_rule?(str)
        str.match /\d?\d-\d?\d/
      end

      def by_interval_rule?(str)
        str.match /\*\/\d?\d/
      end

      def explicity_range_rule?(str)
        str.match /(\d?\d,\d?\d)+/
      end
  end
end
