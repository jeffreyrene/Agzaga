class Mailchimp::CreateNewCustomer < Mailchimp::Base

  def initialize( email_address, first_name='', last_name='', phone_number='' )
    super
    @list_id = ENV['MAILCHIMP_CUSTOMER_LIST_ID']
  end

  def call
    @gibbon.lists( @list_id ).members( Digest::MD5.hexdigest( @email_address.downcase ))
      .upsert(
        body: { email_address: @email_address, status: "subscribed" }
      )
  end

  def update_user_data
    begin
      @gibbon.lists( @list_id ).members( Digest::MD5.hexdigest( @email_address.downcase ))
        .upsert(
          body: { email_address: @email_address, status: "subscribed", merge_fields: {
            FNAME: @first_name,
            LNAME: @last_name,
            PHONE: @phone_number
          }}
        )
    rescue Gibbon::MailChimpError => e
      throw e unless e.detail.include?('unsubscribe, bounce, or compliance')
    end
  end
end

# touched on 2025-05-22T19:07:37.295739Z
# touched on 2025-05-22T19:14:57.852942Z
# touched on 2025-05-22T20:31:42.868407Z
# touched on 2025-05-22T20:40:25.539718Z
# touched on 2025-05-22T23:03:29.954848Z
# touched on 2025-05-22T23:03:56.100991Z
# touched on 2025-05-22T23:23:59.908929Z
# touched on 2025-05-22T23:27:25.454558Z
# touched on 2025-05-22T23:38:19.371441Z
# touched on 2025-06-13T21:14:38.529487Z