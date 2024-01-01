module Spree
  class StripeApplePayVerificationFileController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show
      file_location = "#{Rails.root}/public/apple-developer-merchantid-domain-association"
      send_file(file_location, filename: "apple-developer-merchantid-domain-association")
    end
  end
end

# touched on 2025-05-22T23:29:22.768089Z
# touched on 2025-05-22T23:39:31.576763Z

# touched on 2025-06-13T21:14:17.635709Z