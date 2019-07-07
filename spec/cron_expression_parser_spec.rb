# frozen_string_literal: true

require 'spec_helper'

describe CronExpressionParser::Main do
  class FakeIO
    def print(str)
      str
    end
  end

  let(:fake_io) { FakeIO.new }
  let(:parser) { CronExpressionParser::Parser.new }
  let(:formatter) { CronExpressionParser::Formatter.new }
  subject { CronExpressionParser::Main.new(parser: parser, formatter: formatter, io: fake_io) }
  context 'when pass valid cron string' do
    let(:input) { '*/15 0 1,15 * 1-5 /usr/bin/find' }
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

    it { expect(subject.exec(input)).to eq(output) }
  end

  context 'when pass invalid cron string' do
    let(:input) { 'invalid input' }
    let(:output) { 'Validation Error: Must have 6 parts' }

    it { expect(subject.exec(input)).to eq(output) }
  end
end
