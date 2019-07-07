# frozen_string_literal: true

module CronExpressionParser
  # base class for the rules
  class Rule
    attr_reader :str, :unit, :ranges

    def initialize(str, unit, ranges)
      @str = str
      @unit = unit
      @ranges = ranges
    end

    def exec
      raise NotImplementedError
    end

    def validate_range(range)
      r_start = ranges[unit][0]
      r_end = ranges[unit][1]
      msg = "Not allowed value for #{unit}: '#{str}', allowed range #{r_start}-#{r_end}"
      raise ValidationError, msg unless errors(range, r_start, r_end).empty?
    end

    def errors(range, r_start, r_end)
      errors = []
      range.each do |v|
        errors.push v unless v.between?(r_start, r_end)
      end
      errors
    end
  end
end
