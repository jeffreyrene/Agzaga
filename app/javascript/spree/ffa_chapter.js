$(document).on('turbolinks:load', function() {
  if( $('.ffa_fundraisers.show, .ffa_fundraisers.update').length) {
    ffa_chapter_js(event);
    window.ffa_chapter_js = ffa_chapter_js;

    function countdown() {
      var eventDate = moment('2022-1-25 23:59:00-06:00').tz('America/Chicago').format();
      eventTime = moment(eventDate).format("X");

      var currentDate = moment().tz('America/Chicago').format();
      currentTime = moment(currentDate).format("X");
      var remTime = eventTime - currentTime;
      var duration = moment.duration(remTime*1000, 'milliseconds');
      var interval = 1000;

      document.getElementById("days").textContent = duration.days();
      document.getElementById("hours").textContent = duration.hours();
      document.getElementById("minutes").textContent = duration.minutes();
      setTimeout(countdown, 1000);
    }
    countdown();
  }

  if( $('.ffa_home.index').length) {
    $(document).on('click','#close-icon', {} ,function() {
      document.getElementById("new_interested_chapter").reset();
    });

    if ( $('input[name="interested_chapter[phone_number]"]' ).length > 0) {
      new Cleave( $('input[name="interested_chapter[phone_number]"]' ), {
        numericOnly: true,
        delimiters: ["-", "-"],
        blocks: [3, 3, 4]
      });
    }
  }
});

function ffa_chapter_js(event) {

  $('.custom-ffa-error-message').hide();
  $('.btn-green').on('click', function(){
    if ($('.material-textfield > input').val() == '') {
      $('.custom-ffa-error-message').show();
    }
    else {
      $('.custom-ffa-error-message').hide();
    }
  });

  resident_states = ['FL', 'LA', 'OH', 'VA', 'AR','PA', 'MS']
   $('.notification-red').addClass('notification-hide')

  selected_state = $('.ffa-approved-states').val();
  if(resident_states.includes(selected_state)) {
    $('.notification-red').removeClass('notification-hide');
    !($('.notification-red').hasClass('signed')) && $('.btn-orange-red[type="submit"]').attr('disabled', true);
    ($('#ffa_chapter_advisor_form_downloaded').val()== 'true') && $('.btn-orange-red[type="submit"]').attr('disabled', false);
  }

  $('.ffa-approved-states').on('change', function(){
    selected_state = $('.ffa-approved-states').val();
    if(resident_states.includes(selected_state)) {
      if( $('.notification-red').hasClass('notification-hide')) {
        $('.notification-red').removeClass('notification-hide').addClass('animate-slide-down');
        !($('.notification-red').hasClass('signed')) && $('.btn-orange-red[type="submit"]').attr('disabled', true);
        ($('#ffa_chapter_advisor_form_downloaded').val()== 'true') && $('.btn-orange-red[type="submit"]').attr('disabled', false);

        setTimeout(function(){
          $('.notification-red').removeClass('animate-slide-down');
        }, 400);
      }
    }
    else {
      $('.notification-red').addClass('animate-slide-up');

      $('.btn-orange-red[type="submit"]').attr('disabled', false);

      setTimeout(function(){
        $('.notification-red').addClass('notification-hide').removeClass('animate-slide-up');
      }, 400);
    }
  });

  $('.btn-download').on('click', function(){
    $('#ffa_chapter_advisor_form_downloaded').val('true');
    $('.btn-orange-red[type="submit"]').attr('disabled', false);
  });

  if ( $('input[name="ffa_chapter[phone_number]"]' ).length > 0) {
    new Cleave( $('input[name="ffa_chapter[phone_number]"]' ), {
      numericOnly: true,
      delimiters: ["-", "-"],
      blocks: [3, 3, 4]
    });
  }

  if ( $('input[name="ffa_chapter[ein_number]"]' ).length > 0) {
    new Cleave( $('input[name="ffa_chapter[ein_number]"]' ), {
      numericOnly: true,
      delimiters: ["-"],
      blocks: [2,7]
    });
  }

  if ( $('input[name="ffa_chapter[members]"]' ).length > 0) {
    new Cleave( $('input[name="ffa_chapter[members]"]' ), {
      numeral: true,
      numeralThousandsGroupStyle: 'none'
    });
  }
}

# touched on 2025-05-22T22:28:47.182048Z
