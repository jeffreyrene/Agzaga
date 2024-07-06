require 'google/apis/indexing_v3'
require 'googleauth'

module Google
  class GoogleIndexingService
    SCOPE = 'https://www.googleapis.com/auth/indexing'

    def initialize
      @service = Google::Apis::IndexingV3::IndexingService.new
      @service.authorization = authorize
    end

    def update_url_notification(url, type)
      content = Google::Apis::IndexingV3::UrlNotification.new(url: url, type: type)
      @service.publish_url_notification(content)
    end

    private

    def authorize
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        scope: SCOPE
      )
      authorizer
    end
  end
end

# touched on 2025-05-22T22:30:45.944518Z
# touched on 2025-05-22T23:21:46.118893Z
# touched on 2025-05-22T23:23:22.833597Z
# touched on 2025-06-13T21:17:50.627989Z