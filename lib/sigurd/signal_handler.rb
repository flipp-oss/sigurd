# frozen_string_literal: true

module Sigurd
  # Class that takes any object with a "start" and "stop" method and catches
  # signals to ask them to stop nicely.
  class SignalHandler
    SIGNALS = %i(INT TERM QUIT).freeze
    attr_reader :runner

    # Takes any object that responds to the `start` and `stop` methods.
    # @param runner[#start, #stop]
    def initialize(runner)
      @signal_queue = []
      @reader, @writer = IO.pipe
      @runner = runner
    end

    # Run the runner.
    def run!
      setup_signals
      @runner.start

      loop do
        signal = signal_queue.pop
        case signal
        when *SIGNALS
          @runner.stop
          if Sigurd.exit_on_signal
            exit 0
          else
            raise(SignalException, signal)
          end
        else
          ready = IO.select([reader, writer])

          # drain the self-pipe so it won't be returned again next time
          reader.read_nonblock(1) if ready[0].include?(reader)
        end
      end
    end

  private

    attr_reader :reader, :writer, :signal_queue

    # https://stackoverflow.com/questions/29568298/run-code-when-signal-is-sent-but-do-not-trap-the-signal-in-ruby
    def prepend_handler(signal)
      previous = Signal.trap(signal) do
        yield
        previous.call if previous&.respond_to?(:call)
      end
    end

    # Trap signals using the self-pipe trick.
    def setup_signals
      at_exit { @runner&.stop }
      SIGNALS.each do |signal|
        prepend_handler(signal) do
          unblock(signal)
        end
      end
    end

    # Save the signal to the queue and continue on.
    # @param signal [Symbol]
    def unblock(signal)
      writer.write_nonblock('.')
      signal_queue << signal
    end
  end
end
