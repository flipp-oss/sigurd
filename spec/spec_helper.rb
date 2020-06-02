# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

# Helpers for Executor/DbProducer
module TestRunners
  # Execute a block until it stops failing. This is helpful for testing threads
  # where we need to wait for them to continue but don't want to rely on
  # sleeping for X seconds, which is crazy brittle and slow.
  def wait_for
    start_time = Time.now
    begin
      yield
    rescue Exception # rubocop:disable Lint/RescueException
      raise if Time.now - start_time > 2 # 2 seconds is probably plenty of time! <_<

      sleep(0.1)
      retry
    end
  end

  # Test runner
  class TestRunner
    attr_accessor :id, :started, :stopped, :should_error

    # :nodoc:
    def initialize(id=nil)
      @id = id
    end

    # :nodoc:
    def start
      if @should_error
        @should_error = false
        raise 'OH NOES'
      end
      @started = true
    end

    # :nodoc:
    def stop
      @stopped = true
    end
  end
end

RSpec.configure do |config|
  config.include TestRunners
  config.full_backtrace = true

  # true by default for RSpec 4.0
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.mock_with(:rspec) do |mocks|
    mocks.yield_receiver_to_any_instance_implementation_blocks = true
    mocks.verify_partial_doubles = true
  end
end
