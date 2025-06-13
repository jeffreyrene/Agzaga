class Mailchimp::Base
  def initialize( email_address, first_name='', last_name='', phone_number='', **args )
    @gibbon = Gibbon::Request.new( api_key: ENV['MAILCHIMP_API_KEY'] )
    @email_address = email_address
    @first_name = first_name
    @last_name = last_name
    @phone_number = phone_number
  end
end

# touched on 2025-05-22T23:45:57.502157Z
# touched on 2025-05-22T23:46:45.921280Z

# touched on 2025-06-13T21:16:23.671585Z
# touched on 2025-06-13T21:19:34.436436Z