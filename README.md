# sigurd
Small gem to manage executing looping processes and signal handling.

<p align="center">
  <a href="https://badge.fury.io/rb/sigurd"><img src="https://badge.fury.io/rb/sigurd.svg" alt="Gem Version" height="18"></a>
  <a href="https://codeclimate.com/github/flipp-oss/sigurd/maintainability"><img src="https://api.codeclimate.com/v1/badges/a5fc45a193abadc4e45b/maintainability" /></a>
</p>

# Installation

Add this line to your application's Gemfile:
```ruby
gem 'sigurd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sigurd

# Versioning

We use a version of semver for this gem. Any change in previous behavior 
(something works differently or something old no longer works)
is denoted with a bump in the minor version (0.4 -> 0.5). Patch versions 
are for bugfixes or new functionality which does not affect existing code. You
should be locking your Gemfile to the minor version:

```ruby
gem 'sigurd', '0.0.3'
```

# Usage

Sigurd exposes two classes for use with a third class. The ideas is as follows:

* You have any object which responds to the `start` and `stop` methods.
  This object is called a "Runner". When the `stop` method is called,
  the runner should gracefully shut down.
* You create an `Executor` class - this manages a thread pool for a
  list of runners.
* You create a `SignalHandler` which is the topmost object. This will
  handle the signals sent by the system and gracefully forward the
  requests. You pass the executor into the SignalHandler.
* Finally, you call `start` on the `SignalHandler` to begin the execution.

Sample code:

```ruby
class TestRunner

def start
  loop do
    break if @signal_to_stop
    # do some logic here
  end
end

  def stop
    @signal_to_stop = true
  end
end

runners = (1..2).map { TestRunner.new }
executor = Sigurd::Executor.new(runners, sleep_seconds: 5, logger: Logger.new(STDOUT))
Sigurd::SignalHandler.new(executor).run!
```

If you have only a single runner, you can pass it into the `SignalHandler`
directly, without using an `Executor`:

```ruby
  Sigurd::SignalHandler.new(runner).run!
```

By default, if any of your runners fails, Sigurd will use an exponential
backoff to wait before restarting it. You can instead use the `sleep_seconds`
setting to always sleep a fixed amount of time before retrying. There
is no limit to retries.

## Configuration

By default, sigurd will exit the process when a TERM, KILL or QUIT signal is received. You can change this 
behavior to instead raise the original `SignalException` by setting

    Sigurd.exit_on_signal = true

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/flipp-oss/sigurd .

### Linting

Sigurd uses Rubocop to lint the code. Please run Rubocop on your code 
before submitting a PR.

---
<p align="center">
  Sponsored by<br/>
  <a href="https://corp.flipp.com/">
    <img src="support/flipp-logo.png" title="Flipp logo" style="border:none;"/>
  </a>
</p>
