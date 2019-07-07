# frozen_string_literal: true

require_relative './rules/whole_range'
require_relative './rules/sub_range'
require_relative './rules/by_interval'
require_relative './rules/explicity_range'
require_relative './rules/base_range'

module CronExpressionParser
  class ValidationError < RuntimeError; end

  # String parser
  class Parser
    POSITION = {
      minute: 0,
      hour: 1,
      day_of_month: 2,
      month: 3,
      day_of_week: 4
    }.freeze
    RANGES = {
      minute: [0, 59],
      hour: [0, 23],
      day_of_month: [1, 31],
      month: [1, 12],
      day_of_week: [1, 7]
    }.freeze

    def parse(str)
      str = str.split(/\s+/)
      raise ValidationError, 'Must have 6 parts' if str.size < 6

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
      tu_str = str_for(str, time_unit)
      raise ValidationError, "Unexpected option: '#{tu_str}'" if invalid_str?(tu_str)

      selecte_rule(tu_str, time_unit).exec
    end

    def selecte_rule(str, unit)
      if full_range_rule?(str)
        CronExpressionParser::Rules::WholeRange.new(str, unit, RANGES)
      elsif sub_range_rule?(str)
        CronExpressionParser::Rules::SubRange.new(str, unit, RANGES)
      elsif by_interval_rule?(str)
        CronExpressionParser::Rules::ByInterval.new(str, unit, RANGES)
      elsif explicity_range_rule?(str)
        CronExpressionParser::Rules::ExplicityRange.new(str, unit, RANGES)
      else
        CronExpressionParser::Rules::BaseRange.new(str, unit, RANGES)
      end
    end

    def invalid_str?(str)
      return false if str.match(%r{(?![-,\,,\*,\/,\d]).}).nil?

      true
    end

    def str_for(str, time_unit)
      str[POSITION[time_unit]]
    end

    def full_range_rule?(str)
      str.match(/^\*$/)
    end

    def sub_range_rule?(str)
      str.match(/\d?\d-\d?\d/)
    end

    def by_interval_rule?(str)
      str.match(%r{\*\/\d?\d})
    end

    def explicity_range_rule?(str)
      str.match(/(\d?\d,\d?\d)+/)
    end
  end
end
