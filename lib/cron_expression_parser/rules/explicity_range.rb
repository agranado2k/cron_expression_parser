# frozen_string_literal: true

require_relative '../rule'

module CronExpressionParser
  module Rules
    # rule for explicity range
    class ExplicityRange < CronExpressionParser::Rule
      def exec
        str.split(/,/).map(&:to_i)
      end
    end
  end
end
