module Spree
  class ContactMailer < BaseMailer

    def notify_admin_contact_email(contact, admin_email = 'support@agzaga.com')
      @contact = contact
      subject = "#{@contact.email} sent a new message"
      mail(to: admin_email, from: contact.email, subject: subject)
    end

  end
end

# touched on 2025-05-22T19:22:33.479309Z
# touched on 2025-05-22T22:35:52.121877Z
# touched on 2025-05-22T23:27:41.062065Z
# touched on 2025-05-22T23:38:56.665503Z
