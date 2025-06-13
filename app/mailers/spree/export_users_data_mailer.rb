module Spree
  class ExportUsersDataMailer < BaseMailer
    def export_users_data_email(user, subject = "Exported Users Data", csv_content)
      attachments["UsersData-#{Date.today.to_s}.csv"] = {mime_type: 'text/csv', content: csv_content}
      mail(to: user.email, from: 'hello@agzaga.com', subject: subject)
    end

    def cancel_users_data_export_email(user, subject = "Exported Users Data", csv_content)
      mail(to: user.email, from: 'hello@agzaga.com', subject: subject)
    end
  end
end

# touched on 2025-05-22T20:37:21.593094Z
# touched on 2025-05-22T22:38:54.959868Z
# touched on 2025-05-22T23:37:02.269819Z
