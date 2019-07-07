# frozen_string_literal: true

require 'spec_helper'

describe CronExpressionParser::Formatter do
  context 'basic example' do
    let(:input) do
      {
        minute: [0, 15, 30, 45],
        hour: [0],
        day_of_month: [1, 15],
        month: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        day_of_week: [1, 2, 3, 4, 5],
        command: '/usr/bin/find'
      }
    end
    let(:output) do
      <<~OUTPUT
        minute        0 15 30 45
        hour          0
        day of month  1 15
        month         1 2 3 4 5 6 7 8 9 10 11 12
        day of week   1 2 3 4 5
        command       /usr/bin/find
      OUTPUT
    end

    it { expect(subject.table(input)).to eq(output) }
  end

  context 'second example' do
    let(:input) do
      {
        minute: [0, 45],
        hour: [1],
        day_of_month: [1, 15],
        month: [1, 2, 3, 4, 5, 6, 7, 8],
        day_of_week: [2, 3, 4, 5],
        command: '/usr/bin/ack'
      }
    end
    let(:output) do
      <<~OUTPUT
        minute        0 45
        hour          1
        day of month  1 15
        month         1 2 3 4 5 6 7 8
        day of week   2 3 4 5
        command       /usr/bin/ack
      OUTPUT
    end

    it { expect(subject.table(input)).to eq(output) }
  end
end
