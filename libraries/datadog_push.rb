require 'datadog/statsd'

def push_to_datadog(event)
  statsd = Datadog::Statsd.new('localhost', 8125)
  statsd.event(event[:name], event[:text], aggregation_key: event[:key])
end
