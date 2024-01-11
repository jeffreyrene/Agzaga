if Rails.env.production?
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.breadcrumbs_logger = [:active_support_logger]

    config.traces_sampler = lambda do |context|
      false
    end
  end
end

# touched on 2025-05-22T19:13:28.121629Z
# touched on 2025-05-22T22:55:52.021423Z
# touched on 2025-05-22T23:01:28.470269Z
# touched on 2025-05-22T23:39:42.702962Z

# touched on 2025-06-13T21:14:50.194565Z