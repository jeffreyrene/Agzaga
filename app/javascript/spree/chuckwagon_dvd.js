$(document).on('turbolinks:load', function() {
  if( $('.pages.chuckwagon_dvd').length) {
    var validEmail = validPhone = validName = false;

    $(".chukwagon-win-name").on('input', function() {
      const regex = /^[a-zA-Z ]+$/
      if ( this.value.length < 3 || !regex.test(this.value) )
      {
        $('.chuckwagon-win-name-helper').html('Please enter valid full name')
        validName = false;
      }
      else{
        $('.chuckwagon-win-name-helper').html('')
        validName = true;
        enableSubmit()
      }
    });

    $(".chukwagon-win-phone").on('input focusout', function() {
      const regex = /^\(\d{3}\)\d{3}-\d{4}$/;
      if ( this.value.length < 10 || !regex.test(this.value))
      {
        $('.chuckwagon-win-phone-helper').html('Please enter phone number in format (XXX)XXX-XXXX')
        validPhone = false;
      }
      else{
        $('.chuckwagon-win-phone-helper').html('')
        validPhone = true;
        enableSubmit()
      }
    });

    $(".chukwagon-win-email").on('input focusout', function() {
      const regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
      if ( !regex.test(this.value) )
      {
        $('.chuckwagon-win-email-helper').html('Please enter valid email')
        validEmail= false;
      }
      else{
        $('.chuckwagon-win-email-helper').html('')
        validEmail = true;
        enableSubmit()
      }
    });

    function enableSubmit(){
      if (validEmail && validName && validPhone)
      {
        $('.chukwagon-win-submit').prop('disabled', false);
      }
    }

    if ( $('input[name="store_credit_winner[phone_number]"]' ).length > 0) {
      new Cleave( $('input[name="store_credit_winner[phone_number]"]'), {
        numericOnly: true,
        delimiters: ["(", ")", "-"],
        blocks: [0, 3, 3, 4]
      });
    }

    $('.show-more-content').on('click', function() {
      if($('.product-description-group:visible').length) {
        $('.product-description-group').hide();
        $('.show-more-content').addClass('show-more');
        $('.show-more-content').removeClass('show-less');
        $('.show-more-content').text('Show More');

      } else {
        $('.product-description-group').show();
        $('.show-more-content').removeClass('show-more');
        $('.show-more-content').addClass('show-less');
        $('.show-more-content').text('Show Less');
      }
    });

    $(document).on('click', '#open-upsell-modal', function() {
      $('.review_modal_close').click();
      $('.products-upsell-modal').modal('show');
    });
  }
});

# touched on 2025-05-22T19:10:36.870054Z
