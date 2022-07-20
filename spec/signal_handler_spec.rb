# frozen_string_literal: true

require 'sigurd'

RSpec.describe Sigurd::SignalHandler do
  describe '#run!' do

    it 'starts and stops the runner' do
      runner = TestRunners::TestRunner.new
      expect(runner).to receive(:start)
      expect(runner).to receive(:stop)

      signal_handler = described_class.new(runner)
      Thread.new { sleep 1; Process.kill('TERM', 0) }
      expect { signal_handler.run! }.to raise_error(SystemExit)
    end

    context 'when stay_alive_on_signal is true' do
      it 'should raise a SignalException' do
        Sigurd.stay_alive_on_signal = true
        runner = TestRunners::TestRunner.new
        expect(runner).to receive(:start)
        expect(runner).to receive(:stop)

        signal_handler = described_class.new(runner)
        Thread.new { sleep 1; Process.kill('TERM', 0) }
        expect { signal_handler.run! }.to raise_error(SignalException)
      end
    end

  end
end
