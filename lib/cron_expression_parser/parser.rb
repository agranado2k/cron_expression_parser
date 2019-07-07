# frozen_string_literal: true

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

      if full_range_rule?(tu_str)
        all_range_for(time_unit)
      elsif sub_range_rule?(tu_str)
        sub_range(tu_str, time_unit)
      elsif by_interval_rule?(tu_str)
        interval_range(tu_str, time_unit)
      elsif explicity_range_rule?(tu_str)
        explicity_range(tu_str)
      else
        str = tu_str.to_i
        range = [str]
        validate_range(range, time_unit, str)
        range
      end
    end

    def invalid_str?(str)
      return false if str.match(%r{(?![-,\,,\*,\/,\d]).}).nil?

      true
    end

    def validate_range(range, unit, str)
      r_start = RANGES[unit][0]
      r_end = RANGES[unit][1]
      errors = []
      range.each do |v|
        errors.push v unless v.between?(r_start, r_end)
      end
      msg = "Not allowed value for #{unit}: '#{str}', allowed range #{r_start}-#{r_end}"
      raise ValidationError, msg unless errors.empty?
    end

    def str_for(str, time_unit)
      str[POSITION[time_unit]]
    end

    def all_range_for(time_unit)
      ranges = RANGES[time_unit]
      (ranges[0]..ranges[1]).to_a
    end

    def sub_range(str, unit)
      edges = parse_range_edges(str)
      validate_range(edges.values, unit, str)
      (edges[:start]..edges[:end]).to_a
    end

    def parse_range_edges(str)
      sub_str = str.split('-').map(&:to_i)
      { start: sub_str[0], end: sub_str[1] }
    end

    def interval_range(str, unit)
      r_start = RANGES[unit][0]
      r_end = RANGES[unit][1]
      range = [r_start]
      interval = str.match(%r{^\*\/(\d+)$})[1].to_i

      while (next_period = range.last + interval) <= r_end
        range.push next_period
      end

      range
    end

    def explicity_range(str)
      str.split(/,/).map(&:to_i)
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
