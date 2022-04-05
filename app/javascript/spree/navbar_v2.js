$(document).on('turbolinks:load', function() {

  function countdown() {
    var eventDate = moment('2023-07-05 24:00:00').tz('America/Chicago').format();
    var startDate = moment('2023-06-25 24:00:00').tz('America/Chicago').format();
    var currentDate = moment().tz('America/Chicago').format();

    eventTime = moment(eventDate).format("X");
    startTime = moment(startDate).format("X");
    currentTime = moment(currentDate).format("X");

    var remTime = eventTime - currentTime;

    var duration = moment.duration(remTime*1000, 'milliseconds');
    var interval = 1000;
    if (moment(currentDate).isBetween(startDate, eventDate)) {
      $('#blackfriday-countdown').removeClass('display-hide');
      $('#promocode').addClass('display-hide');

      $(".clipboard-btn-ship").on('click', function(){
        var $tempElement = $("<input>");
        $("body").append($tempElement);
        $tempElement.val($(this).closest(".clipboard-btn-ship").find("span").text()).select();
        document.execCommand("Copy");
        $tempElement.remove();
        $('.clipboard-btn-ship').attr('data-original-title','Copied!');
        $(".clipboard-btn-ship").tooltip('show')
      });

    }else {
      $('#promocode').removeClass('display-hide');
      $('#blackfriday-countdown').addClass('display-hide');
      $('.black-friday-mob-box').addClass('display-hide');
      $('.countdown-notifier').addClass('display-hide');
    }

    setTimeout(countdown, 1000);
  }

  if( $('.navbar_v2').length && !$('.pages.net_wraps, .pages.usa').length) {
    countdown();
  }

  if($('.navbar_v2, #small-nav-list-top-v2, .checkout.edit').length || $('.pages.chuckwagon_dvd').length) {

    const regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;

    $(document).on('click','#add-to-cart-button', {} ,function(){
      $('.list-items').show();
      $('.hide-items').hide();
      $('.cart-title').show();

      if($(document).width() > 768) {
        setTimeout(function() {
          $("#add_to_cart_v2_modal").addClass('modal-right fade');
          $("#add_to_cart_v2_modal").modal('hide');
        }, 10000);
      }
    });

    $("#add_to_cart_v2_modal").on('hidden.bs.modal', function () {
      $("#add_to_cart_v2_modal").removeClass('modal-right fade');
    });

    function setPasswordError() {
      $('#nav_login_password').css('border-color', '#CC2E09');
      $('#login_password_icon').addClass('fas fa-exclamation-circle').removeClass('fa-eye fa-eye-slash fa-check-circle').css('color','#CC2E09');
    }

    function setEmailError() {
      $('#login_email_icon').addClass('fa-exclamation-circle').removeClass('fa-check-circle').css('color','#CC2E09');
    }

    function setEmailValid() {
      $('#login_email_icon').addClass('fa-check-circle').removeClass('fa-exclamation-circle');
      $('.nav-login-email-message').removeClass('error-data').html('');
    }

    $('#password').focusout(function() {
      const password_field = $('#password');

      if ( password_field.val().length <= 5) {
        $('#pass-message').addClass('error-data').html('Error: Password is too short (minimum is 6 characters)');
        setPasswordError();
      }
      else if( password_field.val().length == '' ) {
        $('#pass-message').removeClass('error-data').html('');
        $('#password').css('border-color', '#ACACAC');
        $('#password-icon').addClass('fa-eye').removeClass('fas fa-exclamation-circle fa-eye-slash fa-check-circle').css('color','#E32754');
        $('#password').css('box-shadow', 'none');
      }
    });

    $('.logout-btn').on('click', function(e) {
      e.stopPropagation();
      this.classList.toggle("active");
      var logoutbtn = $('.logout-btn')[0]
      var dropdownContent = $('.confirm-logout')[0];
      if (dropdownContent.style.display === "block") {
        dropdownContent.style.display = "none";
        logoutbtn.style.display = "block";
      } else {
        dropdownContent.style.display = "block";
        logoutbtn.style.display = "none";
      }
    });

    $('.small-navbar-logout-btn').on('click', function(e) {
      e.stopPropagation();
      this.classList.toggle("active");
      var logoutbtn = $('.small-navbar-logout-btn')[0]
      var dropdownContent = $('.small-navbar-confirm-logout')[0];
      if (dropdownContent.style.display === "block") {
        dropdownContent.style.display = "none";
        logoutbtn.style.display = "block";
      } else {
        dropdownContent.style.display = "block";
        logoutbtn.style.display = "none";
      }
    });

    $('.search-btn').mouseover(function(){
      $('.search-btn').attr('src',  $('.search_icon_hover').attr('src'));
    });

    $('.search-btn').mouseout(function(){
      $('.search-btn').attr('src', $('.search_icon').attr('src'));
    });

    $('.search-input').on('click', function(){
      $('.search-input').css('background-color, #EFEFEF');
      $('.search-form_v2').css('background-color, #EFEFEF');
      $('.search-btn').attr('src',  $('.search_icon_hover').attr('src'));
    })

    $('.clipboard-btn').mouseover(function() {
      $(".clipboard-btn").tooltip('hide')
      $('.clipboard-btn').attr('data-original-title','');

    });

    $('.clipboard-btn').mouseout(function() {
      $(".clipboard-btn").tooltip('hide')
      $('.clipboard-btn').attr('data-original-title','');
    });

    $(".clipboard-btn").on('click', function(){
      var $tempElement = $("<input>");
      $("body").append($tempElement);
      $tempElement.val($(this).closest(".clipboard-btn").find("span").text()).select();
      document.execCommand("Copy");
      $tempElement.remove();
      $('.clipboard-btn').attr('data-original-title','Copied!');
      $(".clipboard-btn").tooltip('show')
    });
  }

  $('.hamburger_v2').on('click', function() {
    $('#responsiveModal').modal('toggle');
    $('.list-placeholder').first().removeClass('display-show').html('');
    $('.countdown-notifier').addClass('display-hide');
  });

  $("#cartSlider").modal({
    show: false,
  });

  $(document).on('click', '.cart-btn, #go-to-slider', function(e) {
    if ($(document).width() < 767) {
      return true;
    }
    e.preventDefault();
    $('#cartSlider').modal('show');
    $('#add_to_cart_v2_modal').modal('hide');
    $('.cart-slider').css('z-index', 11);
    window.disablePageScroll();

  });

  $('.cart-slider').css('z-index', -1);

  $(document).on('click', '.close-cart-slider', function (event) {
    if(!$(event.target).is('#cartSlider')) {
      $("#cartSlider").modal('hide');
      $('.cart-slider').css('z-index', -1);
      window.enablePageScroll();
    }
  });

  $(document).on( 'click', '.btn-sub-slider', {}, function() {
    var max_value = parseInt( $(this).next('.product-quantity-slider').attr("max"));
    var qunatity_value = parseInt( $(this).next('.product-quantity-slider').val());

    if ((qunatity_value <= 1) || (qunatity_value > max_value)) {
      event.preventDefault();
      $( this ).addClass( "disable" ).attr( "disabled", true);
      $( this ).parent().next('.stock-error-message').css('display', 'block').html('Minimum Quantity: 1');
    }
    else {
      $('.btn-add-slider').removeClass("disable").attr( "disabled", false);
      $( this ).parent().next('.stock-error-message').css('display', 'none').html('');
    }
  });

  $(document).on( 'click', '.btn-add-slider', {}, function() {
    var qunatity_value = parseInt( $(this).prev('.product-quantity-slider').val());
    var max_value = parseInt( $(this).prev('.product-quantity-slider').attr("max"));

    if ( (max_value > qunatity_value && qunatity_value >= 1) || !max_value ) {
      $('.btn-sub-slider').removeClass("disable").attr( "disabled", false);
      $( this ).parent().next('.stock-error-message').css('display', 'none').html('');
    }
    else if(max_value) {
      event.preventDefault();
      $( this ).addClass("disable").attr( "disabled", true);
      $( this ).parent().next('.stock-error-message').css('display', 'block').html('Available Quantity: '+ max_value);
    }
  });

  $(document).on('input', '.product-quantity-slider', {}, function() {
    var max_value = parseInt($( this ).attr("max"));
    $( this ).prev('.btn-sub-slider').removeClass( 'disable' ).attr( "disabled", false);
    $( this ).next('.btn-add-slider').removeClass( 'disable' ).attr( "disabled", false);
    var prev_quantity = $( this ).parent().next('.stock-error-message').data().quantity
    if($( this ).val() > max_value && $( this ).val() != '') {
      $( this ).val(prev_quantity);
      $( this ).parent().next('.stock-error-message').css('display', 'block').html('Available Quantity: '+ max_value);
      event.preventDefault();
    }
    else {
      $( this ).parent().next('.stock-error-message').css('display', 'none').html('');
    }
  });

  if ($("#dollarDropdownMenuButton").children().hasClass('green-dollar-icon')) {
    setTimeout(function(){
      $("#dollarDropdownMenuButton").click();
    },5000)
  }

  $(window).scroll(function () {
    var scroll = $(window).scrollTop();
    var screen_width = $( window ).width();

    if (scroll > 161 && screen_width <= 767) {
      $('#scroll-hamburger-v2').show();
      $(".small-cart-box").css("display", "block");
      $(".small-search-bar-v2").addClass('auto-width');
      $('.small-top-bar-v2').css('margin-bottom','0px');
      $("#scroll-hide").css("display","none");
      $(".small-nav-v2").addClass("minified");
    } else {
      $("#scroll-hamburger-v2").css("display", "none");
      $("#mob-cart-box").css("display", "none");
      $(".small-search-bar-v2").removeClass('auto-width');
      $('.small-top-bar-v2').css('margin-bottom','12px');
      $('.small-bottom-bar-v2').css('padding-top','0px');
      $("#scroll-hide").css("display","flow-root");
      $(".small-nav-v2").removeClass("minified");
    }

    if(scroll > 161 && screen_width <= 767){
      $('.cta-card').css('top', '70px');
    } else if(screen_width <= 767){
      $('.cta-card').css('top', '161px');
    }
  });

  $(document).on('click', '#continue-to-login', function() {
    $('.checkout-registration-modal').modal('hide');
  });
});

$(document).on('click', '.taxonsList .back', function() {
  const $this = $(this);
  $this.parents('.skeleton').first().removeClass('animate__slideInRight').addClass('animate__slideOutRight');

  setTimeout(function(){
    $this.parents('.list-placeholder').first().removeClass('display-show').html('');
  }, 1000);
});

$(document).on('click', '.parent_taxonomy', function() {
  if($(this).hasClass('has_children')) {
    var children_div = ''
    var children_count = $(this).find('#children_count').val()
    for (let i = 0; i < children_count; i++) {
      children_div += '<div class="nav_item-lists"></div>'
    }
    var skeleton = `<div class='taxonsList overlay animate__animated'>
                      <div class='overlay-left'>
                        <div class='is-loading'>
                          <div class='nav_header_heading'></div>
                          ${children_div}
                        </div>
                      </div>
                    </div>`
    $('.list-placeholder').last().append(skeleton).addClass('display-show');
    $('.taxonsList').last().addClass('display-show animate__slideInRight skeleton');
  }
});

# touched on 2025-05-22T20:42:25.228117Z
# touched on 2025-05-22T22:32:59.852885Z
