# frozen_string_literal: true

require 'spec_helper'

describe CronExpressionParser::Parser do
  let!(:base_output) do
    {
      minute: [0],
      hour: [0],
      day_of_month: [1],
      month: [1],
      day_of_week: [1],
      command: '/usr/bin/find'
    }
  end

  def output(override)
    base_output.merge(override)
  end

  context 'when receive valid string' do
    context 'basic input example' do
      let(:input) { '*/15 0 1,15 * 1-5 /usr/bin/find' }
      let(:local_output) do
        {
          minute: [0, 15, 30, 45],
          hour: [0],
          day_of_month: [1, 15],
          month: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
          day_of_week: [1, 2, 3, 4, 5],
          command: '/usr/bin/find'
        }
      end

      it { expect(subject.parse(input)).to eq(local_output) }
    end

    context 'when using different variations for time period' do
      context 'when define one time unit' do
        let(:input) { '0 0 5 1 1 /usr/bin/find' }
        let(:local_output) { output(day_of_month: [5]) }

        it { expect(subject.parse(input)).to eq(local_output) }
      end

      context 'when define sub range of time unit' do
        let(:input) { '0 0 2-6 1 1 /usr/bin/find' }
        let(:local_output) { output(day_of_month: [2, 3, 4, 5, 6]) }

        it { expect(subject.parse(input)).to eq(local_output) }
      end

      context 'when define time unit range for every interval' do
        let(:input) { '*/20 0 1 1 1 /usr/bin/find' }
        let(:local_output) { output(minute: [0, 20, 40]) }

        it { expect(subject.parse(input)).to eq(local_output) }
      end

      context 'when define time unit explicity range' do
        let(:input) { '10,20,25 0 1 1 1 /usr/bin/find' }
        let(:local_output) { output(minute: [10, 20, 25]) }

        it { expect(subject.parse(input)).to eq(local_output) }
      end

      context 'when define command' do
        let(:input) { '0 0 1 1 1 /different/command' }
        let(:local_output) { output(command: '/different/command') }

        it { expect(subject.parse(input)).to eq(local_output) }
      end

      context 'when define all time units in valid range' do
        context 'for minutes' do
          let(:input) { '* 0 1 1 1 /usr/bin/find' }
          let(:local_output) { output(minute: (0..59).to_a) }

          it { expect(subject.parse(input)).to eq(local_output) }
        end

        context 'for hours' do
          let(:input) { '0 * 1 1 1 /usr/bin/find' }
          let(:local_output) { output(hour: (0..23).to_a) }

          it { expect(subject.parse(input)).to eq(local_output) }
        end

        context 'for day of month' do
          let(:input) { '0 0 * 1 1 /usr/bin/find' }
          let(:local_output) { output(day_of_month: (1..31).to_a) }

          it { expect(subject.parse(input)).to eq(local_output) }
        end

        context 'for month' do
          let(:input) { '0 0 1 * 1 /usr/bin/find' }
          let(:local_output) { output(month: (1..12).to_a) }

          it { expect(subject.parse(input)).to eq(local_output) }
        end

        context 'for day of week' do
          let(:input) { '0 0 1 1 * /usr/bin/find' }
          let(:local_output) { output(day_of_week: (1..7).to_a) }

          it { expect(subject.parse(input)).to eq(local_output) }
        end
      end
    end
  end

  context 'when receive invalid string' do
    let(:error_class) { CronExpressionParser::ValidationError }

    context 'when input has less then 6 part' do
      let(:input) { '*/15 1,15 * 1-5 /usr/bin/find' }
      let(:msg) { 'Must have 6 parts' }
      it { expect { subject.parse(input) }.to raise_error error_class, msg }
    end

    context 'when one of the time inputs is not valid' do
      let(:input) { '*/15 0+1 1,15 * 1-5 /usr/bin/find' }
      let(:msg) { 'Unexpected option: \'0+1\'' }
      it { expect { subject.parse(input) }.to raise_error error_class, msg }
    end

    context 'when unit time is not allowed' do
      let(:input) { '60 0 1 1 1 /usr/bin/find' }
      let(:msg) { 'Not allowed value for minute: \'60\', allowed range 0-59' }
      it { expect { subject.parse(input) }.to raise_error error_class, msg }
    end

    context 'when unit time is out of range' do
      let(:input) { '00 0 1 0-4 1 /usr/bin/find' }
      let(:msg) { 'Not allowed value for month: \'0-4\', allowed range 1-12' }
      it { expect { subject.parse(input) }.to raise_error error_class, msg }
    end
  end
end
