module Spree
  class ExportFfaFundraiserMailer < BaseMailer
    def export_ffa_fundraiser_email(user, subject = "Exported FFA Fundraiser", csv_content)
      attachments["FFAFundraiser-#{Date.today.to_s}.csv"] = {mime_type: 'text/csv', content: csv_content}
      mail(to: user.email, from: 'hello@agzaga.com', subject: subject)
    end

    def cancel_ffa_fundraiser_export_email(user, subject = "Exported FFA Fundraiser", csv_content)
      mail(to: user.email, from: 'hello@agzaga.com', subject: subject)
    end
  end
end

# touched on 2025-05-22T23:19:27.092684Z
# touched on 2025-05-22T23:42:05.871637Z

# touched on 2025-06-13T21:20:02.546348Z