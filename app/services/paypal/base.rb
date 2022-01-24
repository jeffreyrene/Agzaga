class Paypal::Base

  END_POINT = 'https://api-m.paypal.com/v1/oauth2/token'

  def initialize
    @client_id =  ENV['PAYPAL_CLIENT_ID']
    @client_secret = ENV['PAYPAL_CLIENT_SECRET']
    credentials       = Paypal::Credentials.last
    @access_token     = credentials.access_token
    @access_token_exp = credentials.access_token_expiry
  end

  def get_access_token( callback_name, *args)
    url = URI(END_POINT)

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request["Authorization"] = "Basic #{Base64.strict_encode64("#{@client_id}:#{@client_secret}")}"
    request.body = "grant_type=client_credentials&ignoreCache=true&return_authn_schemes=true&return_client_metadata=true&return_unconsented_scopes=true"
    response = https.request(request)

    if response.code == '200'
      data = JSON.parse(response.read_body)
      @access_token = data['access_token']
      @access_token_exp = data['expires_in'].to_i.seconds.after

      Paypal::Credentials.last.update(access_token: @access_token, access_token_expiry: @access_token_exp)

      add_Paypal_log(response.code, 'Access token refreshed successfully', args[0])
      send(callback_name, *(args))

    else
      log_error_and_notify_admin(response, 'Cannot refresh token', args[0])
    end
  end

  def log_error_and_notify_admin response, message = '', order_id = nil
    log = Spree::PaypalTrackerLog.new

    data = JSON.parse(response.read_body)
    error_text = data['error'].present? ? data['error'].humanize : ''

    log.response = "#{message}#{'.' if message.present?} #{error_text}"

    log.status_code = response&.code
    log.order_id =  order_id if order_id.present?
    log.save

    PaypalTrackerNotificationMailer.error_email(log.response).deliver
  end

  def add_Paypal_log status_code, message, order_id = nil
    log = Spree::PaypalTrackerLog.new()
    log.status_code = status_code
    log.response    = message
    log.order_id    = order_id if order_id.present?
    log.save
  end

end

# touched on 2025-05-22T22:33:06.704809Z
# touched on 2025-05-22T23:04:28.940249Z
# touched on 2025-05-22T23:30:22.220647Z
