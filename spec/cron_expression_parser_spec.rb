# frozen_string_literal: true

require 'spec_helper'

describe CronExpressionParser::Main do
  context 'when pass valid cron string' do
    let(:input) { '*/15 0 1,15 * 1-5 /usr/bin/find' }
    let(:output) do
      <<~END
        12345678901234
        minute        0 15 30 45
        hour          0
        day of mount  1 15
        month         1 2 3 4 5 6 7 8 9 10 11 12
        day of week   1 2 3 4 5
        command       /usr/bin/find
      END
    end

    it { expect(subject.parse(input)).to eq(output) }
  end

  context 'when pass invalid cron string' do
    it 'should display message error'
  end
end
