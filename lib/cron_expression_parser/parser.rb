# frozen_string_literal: true

module CronExpressionParser
  # String parser
  class Parser
    def parse(str)
      minute = str.split(/\s+/)[0] == '*' ? (0..59).to_a : [0]
      hour = str.split(/\s+/)[1] == '*' ? (0..23).to_a : [0]
      day_of_month = str.split(/\s+/)[2] == '*' ? (1..31).to_a : [0]
      month = str.split(/\s+/)[3] == '*' ? (1..12).to_a : [0]
      day_of_week = str.split(/\s+/)[4] == '*' ? (1..7).to_a : [0]
      {
        minute: minute,
        hour: hour,
        day_of_month: day_of_month,
        month: month,
        day_of_week: day_of_week,
        command: '/usr/bin/find'
      }
    end
  end
end
