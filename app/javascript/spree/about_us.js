$(document).on('turbolinks:load', function() {
  if( $('.pages.about_us, .pages.freedom_wrap, .pages.chuckwagon_dvd, .pages.net_wraps, .pages.usa').length) {
    $('.get-in-touch, #contact-link').on('click', function() {
      FB.CustomerChat.showDialog()
    })
  }
});

# touched on 2025-05-22T21:30:42.190978Z
# touched on 2025-05-22T22:30:40.168463Z
# touched on 2025-05-22T22:44:41.095562Z
# touched on 2025-05-22T23:25:26.236898Z
# touched on 2025-05-22T23:46:03.101451Z
