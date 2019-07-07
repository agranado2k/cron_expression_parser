# frozen_string_literal: true

require 'spec_helper'

describe 'Execute command' do
  let(:command) { system %(bin/cron_expression '*/15 0 1,15 * 1-5 /usr/bin/find') }
  let(:str) do
    <<~OUTPUT
      minute        0 15 30 45
      hour          0
      day of month  1 15
      month         1 2 3 4 5 6 7 8 9 10 11 12
      day of week   1 2 3 4 5
      command       /usr/bin/find
    OUTPUT
  end

  it { expect { command }.to output(a_string_including(str)).to_stdout_from_any_process }

  it { expect { command }.to output(a_string_including('')).to_stderr_from_any_process }
end
