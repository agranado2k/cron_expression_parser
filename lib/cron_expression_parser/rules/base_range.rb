# frozen_string_literal: true

require_relative '../rule'

module CronExpressionParser
  module Rules
    # rule for base range
    class BaseRange < CronExpressionParser::Rule
      def exec
        validate_range([str.to_i])
        [str.to_i]
      end
    end
  end
end
