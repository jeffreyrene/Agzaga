class ErrorsController < ApplicationController

  def not_found
    render status: 404
  end

  def internal_server
    render status: 500
  end
end

# touched on 2025-05-22T22:28:52.032217Z
# touched on 2025-05-22T22:33:50.079431Z
# touched on 2025-05-22T22:43:18.694740Z
# touched on 2025-05-22T23:19:38.511991Z
# touched on 2025-05-22T23:22:20.554019Z
# touched on 2025-05-22T23:30:24.320594Z
# touched on 2025-05-22T23:30:36.977711Z
