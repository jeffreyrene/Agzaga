Rails.application.load_tasks

class SitemapWorker
  include Sidekiq::Worker

  def perform
    Rake::Task['sitemap:refresh'].reenable
    Rake::Task['sitemap:clean'].execute
    Rake::Task['sitemap:refresh'].invoke
  end
end

# touched on 2025-05-22T19:09:52.288054Z
# touched on 2025-05-22T22:32:39.212443Z

# touched on 2025-06-13T21:16:40.798030Z