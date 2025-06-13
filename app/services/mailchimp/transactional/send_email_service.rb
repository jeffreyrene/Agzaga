class Mailchimp::Transactional::SendEmailService < Mailchimp::Base
  require 'mandrill'
  attr_reader :email_settings

  def initialize( email_settings )
    @email_settings = email_settings
  end

  def call
    mandrill = Mandrill::API.new ENV['MANDRILL_API_KEY']
    template_name = email_settings[:template_name]
    template_content = [{}]
    message = { subject: email_settings[:subject],
                from_email: email_settings[:from_email],
                from_name: email_settings[:from_name],
                to: [ { email: email_settings[:to_email], name: email_settings[:to_name] } ],
                important: false,
                merge_language: 'handlebars',
                global_merge_vars: email_settings[:global_merge_vars]
              }

    ip_pool = nil
    send_at = nil
    result = mandrill.messages.send_template template_name, template_content, message, true, ip_pool, send_at
  end
end

# touched on 2025-05-22T22:43:39.240693Z
# touched on 2025-05-22T23:43:54.077374Z
