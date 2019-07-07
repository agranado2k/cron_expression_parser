# frozen_string_literal: true

require_relative '../rule'

module CronExpressionParser
  module Rules
    # rule for range by interval
    class ByInterval < CronExpressionParser::Rule
      def exec
        r_start = ranges[unit][0]
        r_end = ranges[unit][1]
        calculate_range(r_start, r_end)
      end

      private

      def calculate_range(r_start, r_end)
        range = [r_start]
        while (next_period = range.last + interval) <= r_end
          range.push next_period
        end
        range
      end

      def interval
        str.match(%r{^\*\/(\d+)$})[1].to_i
      end
    end
  end
end
