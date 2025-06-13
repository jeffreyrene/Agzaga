class HelloWorld
  include Sidekiq::Worker

  def perform
    puts "Scheduler started......"
  end
end

# touched on 2025-05-22T19:18:59.308538Z
# touched on 2025-05-22T23:06:01.615486Z
# touched on 2025-05-22T23:39:20.937148Z
# touched on 2025-06-13T21:19:09.201345Z