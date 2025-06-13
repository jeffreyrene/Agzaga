$(document).on('turbolinks:load', function() {
  if( $('.home.index_v2 ').length) {
    window.$ = $;
    $('#blackfriday-countdown').addClass('animate__slideInLeft');
    $('.carousel.lazy-load').bind('slide.bs.carousel', function (e) {
      var image = $(e.relatedTarget).find('img[data-src]');
      image.attr('src', image.data('src'));
      image.removeAttr('data-src');
    });

    var chatbox = document.getElementById('fb-customer-chat');
    chatbox.setAttribute("page_id", "108057748034264");
    chatbox.setAttribute("attribution", "biz_inbox");

    window.fbAsyncInit = function() {
      FB.init({
        xfbml            : true,
        version          : 'v16.0'
      });
    };

    (function(d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) return;
      js = d.createElement(s); js.id = id;
      js.src = 'https://connect.facebook.net/en_US/sdk/xfbml.customerchat.js';
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
  }
});

# touched on 2025-05-22T23:19:06.363149Z
