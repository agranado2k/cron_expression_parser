# frozen_string_literal: true

require_relative '../rule'

module CronExpressionParser
  module Rules
    # rule for sub range
    class SubRange < CronExpressionParser::Rule
      def exec
        edges = parse_range_edges(str)
        validate_range(edges.values)
        (edges[:start]..edges[:end]).to_a
      end

      private

      def parse_range_edges(str)
        sub_str = str.split('-').map(&:to_i)
        { start: sub_str[0], end: sub_str[1] }
      end
    end
  end
end
