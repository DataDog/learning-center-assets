Datadog.configure do |c|
    c.env = 'dev'
    c.service = 'conduit'
    c.tracing.sampling.default_rate = 1
    c.profiling.enabled = true
end