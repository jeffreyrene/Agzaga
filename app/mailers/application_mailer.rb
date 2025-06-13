class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  include ApplicationHelper
  helper :application

end

# touched on 2025-05-22T22:54:40.419720Z
# touched on 2025-06-13T21:21:59.883957Z