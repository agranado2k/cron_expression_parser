# frozen_string_literal: true

require_relative '../rule'

module CronExpressionParser
  module Rules
    # rule for whole range
    class WholeRange < CronExpressionParser::Rule
      def exec
        (ranges[unit][0]..ranges[unit][1]).to_a
      end
    end
  end
end
