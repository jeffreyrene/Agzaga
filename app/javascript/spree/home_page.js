$(document).on('turbolinks:load', function() {
  setTimeout(function(){
    $(".loader").fadeOut("slow");
    $(".loader").css('display', 'none');
  }, 5000);

  if( $('.home.index').length || $('.products.show').length || $('.product_categories.index').length || $('.orders.edit').length || $('.orders.show').length || $('.products.index').length || $('.favorites.index').length || $('.taxons.show').length || $('.home.index_v2').length || $('.pages.chuckwagon_dvd').length || $('.pages.usa').length)  {
    function navigationFill() {
      setActiveFill();
      removeFill();
      setTimeout(function(){
        removeFill();
      }, 100);
    }
    if (window.location.href.includes('login=true')) {
      $('.btn-usr')[0].click();
    }

    function setActiveFill() {
      var progressbar = $(".owl-theme .owl-dots .owl-dot.active span");
      $(progressbar).animate({ width: "100%" }, 'fast');
    }

    function removeFill(){
      var pr = $(".owl-theme .owl-dots .owl-dot span");
      $(pr).css({ width: "0%" });
    }

    $('.close-popup').on('click', function() {
      $('#pick-up-popup').removeClass('show-popup');
    });

    $("#featured-categories").owlCarousel({
      loop: false,
      rewind: true,
      margin: 0,
      nav: true,
      checkVisible: true,
      responsiveClass: true,
      navText: [],
      dots: true,
      items: 6,
      autoWidth:true,
      responsive: {
        0: {
          items: 1
        },
        500: {
          items: 3
        },
        930: {
          items: 4
        },
        1200: {
          items: 5
        },
        1400: {
          items: 6,
          loop: false
        }
      },
      onInitialized: setDotsWidth,
    });

    function setDotsWidth(event){
      no_of_dots = event.currentTarget.querySelectorAll('.owl-dot').length
      dotWidth = (87 / no_of_dots ) + "%";
      this.$element.children('.owl-dots').children('.owl-dot').css({ width: dotWidth });
    }

    function populateRelatedProducts() {
      $("#featured-carousel, #addition-carousel").owlCarousel({
        loop: false,
        rewind: true,
        margin: 12,
        nav: true,
        checkVisible: true,
        responsiveClass: true,
        navText: [],
        dots: true,
        items: 4,
        autoWidth:true,
        responsive: {
          0: {
            items: 1,
            dots: true,
            nav: true
          },
          500: {
            items: 3,
            dots: true,
            nav: true
          },
          1200: {
            items: 4,
            dots: true,
            nav: true
          },
          1441: {
            margin: 24,
            dots: true,
            nav: true
          }
        }
      });

      $("#featured-carousel, #addition-carousel, #featured-categories").on('changed.owl.carousel', function(event) {
        navigationFill();
        no_of_dots = event.currentTarget.querySelectorAll('.owl-dot').length
        dot_width = (87 / no_of_dots) + "%";
        var pr = $(this).children('.owl-dots').children('.owl-dot');
        $(pr).css({ width: dot_width });
      });
    }

    window.populateRelatedProducts = populateRelatedProducts;
    populateRelatedProducts();

    $("#home_page_review").owlCarousel({
      loop: false,
      rewind: true,
      margin: 10,
      nav: true,
      checkVisible: true,
      responsiveClass: true,
      navText: [],
      items: 4,
      autoWidth:true,
      center: true,
      responsive: {
        0: {
          items: 1,
          center: true,
          stagePadding: 30,
          margin: 16,
          loop: true,
          autoWidth: false
        },
        460: {
          items: 2,
          center: true,
          loop: true,
          autoWidth: false,
          margin: 16,
          afterInit: 350
        },

        767: {
          items: 2,
          center: false
        },
        1200: {
          items: 4,
          center: false
        },
        1920: {
          center: true,
          loop: true
        }
      }
    });

    document.addEventListener("turbolinks:before-cache", function() {
      $('#featured-carousel, #addition-carousel, #featured-categories').owlCarousel('destroy');
    });

    $("#featured-carousel, #addition-carousel, #featured-categories").on('changed.owl.carousel', function(event) {
      navigationFill();
      no_of_dots = event.currentTarget.querySelectorAll('.owl-dot').length
      dot_width = (87 / no_of_dots) + "%";
      var pr = $(this).children('.owl-dots').children('.owl-dot');
      $(pr).css({ width: dot_width });
    });

    $("#shop_by_brand_carousel").owlCarousel({
      loop: true,
      margin: 10,
      nav: true,
      checkVisible: false,
      responsiveClass: true,
      navText: [],
      dots: true,
      responsive: {
        0: {
          items: 1
        },
        500: {
          items: 2
        },
        768: {
          items: 3
        },
        991: {
          items: 4
        },
        1199: {
          items: 5
        },
        1200: {
          items: 6
        }
      }
    });

    $('#new-product-icons-crousel, .quick-view-images-carousel').owlCarousel({
      items : 1,
      dots: false,
      stagePadding: 118,
      nav: true,
      navText: ["<div class='prev_slide'></div>","<div class='next_slide'></div>"],
      margin: 8,
      responsiveClass: false,
      slideBy: 1,
    }).on('changed.owl.carousel', changeProductImage);

    function changeProductImage(e) {
      var index = parseInt(e.item.index) + 1;
      var url = $('#new-product-icons-crousel .owl-item:nth-child('+index+') .item img').attr('src');
      url = url == undefined ? $(this).find('.owl-item:nth-child('+index+') .item img').attr('src') : url;
      $(this).siblings('.product-image-lg-group').children('img').attr('src', url);
    }

    $('#new-product-icons-crousel .item').on('click', function(){
      var url = $(this).children('img').attr('src');
      $('#product-image-lg').attr('src', url);
    });

    $( '.home-bttn' ).on( 'click',function(){
      $("[data-dismiss=modal]").trigger({ type: "click" });
    });
  }

  $( '.color-options input:radio' ).change(function() {
    $( '.radio-item' ).removeClass( 'color-selected' )
                    .addClass( 'color-un_selected' );

    $(this).closest( '.radio-item' ).addClass( 'color-selected' )
                                  .removeClass( 'color-un_selected' );
  });

  $( '.like-button' ).on( 'click', function() {
    if (this.src.split('assets')[1] === "/circle_like_ellipse.svg"  ) {
      $(this).attr( 'src', "/assets/circle_like_warm.svg" );
    }

    else {
      $(this).attr( 'src', "/assets/circle_like_ellipse.svg" );
    }
  });

  $('.size-options p').click( function(){
    if ( $( this ).hasClass( 'categories' )) {
      $(this).parent().prev( '.select-size-btn' ).text( $(this).text() )
                                              .addClass( 'size-selected bold' );
    }
    else {
      $(this).parent().prev( '.select-size-btn' ).text($(this).text())
                                              .removeClass( 'bold' )
                                              .addClass( 'size-selected' );
    }
    $( '.dropdown-toggle' ).after().removeClass( 'dropdown-show' )
                                 .removeClass( 'arrow-up' );
  });

  $( '.home-bttn' ).on( 'click',function(){
    $("[data-dismiss=modal]").trigger({ type: "click" });
  });

  $( '.select-size-btn' ).on( 'click', function(){
    if( $( '.dropdown-toggle' ).after().hasClass( 'arrow-up' )) {
      $( '.dropdown-toggle' ).after().removeClass( 'arrow-up' );
    }
    else {
      $( '.dropdown-toggle' ).after().addClass( 'arrow-up' );
    }
  });

  $('.more-info, .product-image-link').on('click', function(e) {
    $('.product-quick-view .modal.show').modal('hide');
  });

  setTimeout(function() {
    $('.search-tag').on('click',function(e) {
      $($(this).data('target'))[0].click();
      return false;
    });
  }, 2000);

  if (!$('.products.deals').length) {
    $('.product-card .name, .product-card .image-container').mouseover(function() {
      $(this).parent('.product-card').addClass('hoverclass');
    });

    $('.product-card .image-container, .product-card .name').mouseleave(function(){
      $(this).parent('.product-card').removeClass('hoverclass');
    });
  }

  $(window).on("beforeunload", function() {
    if ($('#checkout_form_confirm').length) {
      setTimeout(function(){
        $(".loader").css('display', 'block');
      }, 3000);
    }
  });

  if ($('.order-show').length) {
    $(".loader").css('display', 'block');
  };

});

$(document).ready(function() {
  if( $('.home.index').length || $('.products.show, .pages.net_wraps, .pages.usa').length  || $('.product_categories.index').length || $('.orders.edit').length || $('.orders.show').length || $('.products.index').length || $('.favorites.index').length || $('.taxons.show').length || $('.products.deals').length || $('.home.index_v2').length ||  $('.products.gift_page').length ||  $('.pages.august_event').length ||  $('.pages.chuckwagon_dvd').length || $('.checkout.edit').length) {
    $(document).on('input', '.quantity', function() {
      var min_value = parseInt($( this ).attr("min"));
      var max_value = parseInt($( this ).attr("max"));
      $( this ).prev('.sub-btn').removeClass( 'disable_btn' ).attr( "disabled", false);
      $( this ).next('.add-btn').removeClass( 'disable_btn' ).attr( "disabled", false);
      if($(this).hasClass('modal-quantity-field') && $( this ).val() == max_value && $( this ).val() != '') {
        max_value = max_value - 1;
        $( this ).val(max_value);
      }

      if($( this ).val() > max_value && $( this ).val() != '') {
        $( this ).parent().next('.stock-error-message').css('display', 'block').html('Available Quantity: '+ max_value);
        $('.need-more-quantity-group').show();
      }

      else if ($( this ).val() < min_value && $( this ).val() != '') {
        $( this ).parent().next('.stock-error-message').css('display', 'block').html('Invalid Quantity');
        $('.checkout-add-to-cart-button').hide();
        $('.checkout-remove-from-cart-button').show().addClass('d-block');
        if($(this).hasClass('modal-quantity-field')) {
          $('.stock-error-message').hide();
        }
      }

      else {
        $(this).prev().parents('.gift-set-section').children('.mob-quantity').children('.gift-btns-group').children('.quantity-btn-group').children('.quantity').val($( this ).prev('.quantity').val())
        $( this ).parent().next('.stock-error-message').css('display', 'none').html('');
        $('.need-more-quantity-group').hide();
        $('.checkout-add-to-cart-button').show();
        $('.checkout-remove-from-cart-button').hide().removeClass('d-block');
      }
    });

    $(document).on( 'click', '.sub-btn', function() {
      var min_value = parseInt($( this ).next('.quantity').attr("min"));
      if ($( this ).next('.quantity').val() >= min_value ) {
        $( this ).parent().next('.stock-error-message').css('display', 'none').html('');
        $( this ).next('.quantity').next('.add-btn').removeClass( 'disable_btn' ).attr( "disabled", false);
        $( this ).next('.quantity').val( parseInt( $(this).next('.quantity').val()) - 1 );
        $(this).prev().parents('.gift-set-section').children('.mob-quantity').children('.gift-btns-group').children('.quantity-btn-group').children('.quantity').val($( this ).prev('.quantity').val())
        $('.need-more-quantity-group').hide();
      }
      if ($( this ).next('.quantity').val() < min_value ) {
        $( this).addClass( 'disable_btn' ).attr( "disabled", true);
        $( this  ).parent().next('.stock-error-message').css('display', 'block').html('Invalid Quantity');
        $('.checkout-add-to-cart-button').hide();
        $('.checkout-remove-from-cart-button').show().addClass('d-block');
        if($(this).next('.quantity').hasClass('modal-quantity-field')) {
          $('.stock-error-message').hide();
        }
      }
    });

    $(document).on( 'click', '.add-btn', function() {
      var qunatity_value = parseInt($( this ).prev('.quantity').val());
      var max_value = parseInt($( this ).prev('.quantity').attr("max"));
      if ( max_value > qunatity_value && $( this ).prev('.quantity')[0].hasAttribute("max")) {
        $( this ).parent().next('.stock-error-message').css('display', 'none').html('');
        $('.checkout-add-to-cart-button').show();
        $('.checkout-remove-from-cart-button').hide().removeClass('d-block');
        $( this ).prev('.quantity').prev('.sub-btn').removeClass( 'disable_btn' ).attr( "disabled", false);
        $( this ).prev('.quantity').val( parseInt( $(this).prev('.quantity').val()) + 1 );
        $(this).prev().parents('.gift-set-section').children('.mob-quantity').children('.gift-btns-group').children('.quantity-btn-group').children('.quantity').val($( this ).prev('.quantity').val())
      }
      else if(!$( this ).prev('.quantity')[0].hasAttribute("max")) {
        $( this ).prev('.quantity').val( parseInt( $(this).prev('.quantity').val()) + 1 );
        $( this ).prev('.quantity').prev('.sub-btn').removeClass( 'disable_btn' ).attr( "disabled", false);
        $( this ).parent().next('.stock-error-message').css('display', 'none').html('');
        $('.checkout-add-to-cart-button').show();
        $('.checkout-remove-from-cart-button').hide().removeClass('d-block');
        $(this).prev().parents('.gift-set-section').children('.mob-quantity').children('.gift-btns-group').children('.quantity-btn-group').children('.quantity').val($( this ).prev('.quantity').val())
      }

      if ( max_value == $( this ).prev('.quantity').val() && $( this ).prev('.quantity')[0].hasAttribute("max")) {
        $( this ).addClass( 'disable_btn' ).attr( "disabled", true);
        if($(this).prev('.quantity').hasClass('modal-quantity-field')) {
          $( this ).prev('.quantity').val(max_value - 1);
          $( this ).parent().next('.stock-error-message').css('display', 'block').html('Available Quantity: '+ (max_value - 1));
        }
        else {
          $( this ).parent().next('.stock-error-message').css('display', 'block').html('Available Quantity: '+ max_value);
          $('.need-more-quantity-group').show();
        }
      }
    });

    $(document).on('click', '.checkout-qty-modal-btn', function() {
      $('.stock-error-message').hide();
      $('.add-btn, .sub-btn').attr("disabled", false).removeClass('disable_btn');
      var target_modal = $(this).data('target');
      var quantity = $(target_modal).find('.modal-quantity-field').data('quantity');
      $(target_modal).find('.modal-quantity-field').val(quantity)
      if(quantity > 0) {
        $('.checkout-add-to-cart-button').show();
        $('.checkout-remove-from-cart-button').hide().removeClass('d-block');
      }
      else {
        $('.checkout-add-to-cart-button').hide();
        $('.checkout-remove-from-cart-button').show().addClass('d-block');
      }
    });
  }
});

# touched on 2025-05-22T20:33:29.630121Z
# touched on 2025-05-22T20:38:16.644632Z
# touched on 2025-05-22T20:43:46.763217Z
# touched on 2025-05-22T23:36:47.273410Z
