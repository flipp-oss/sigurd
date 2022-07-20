# frozen_string_literal: true

require 'sigurd/version'
require 'sigurd/executor'
require 'sigurd/signal_handler'

# :nodoc:
module Sigurd

  class << self
    attr_accessor :exit_on_signal
  end

end
