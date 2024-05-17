$(document).on('turbolinks:load', function() {
  if(!$('.checkout.edit').length) {
    window.$ = $;
  }

  $(document).on('click', '.cart-body-tabs-content', function() {
    $(this).parent().children().removeClass('cart-body-tab-selected');
    $(this).addClass('cart-body-tab-selected');

    if ($(this).attr('class').includes('saveditem')) {
      $('.cart-body-cart-section').addClass('cart-body-section-visible');
      $('.cart-body-saved-items-section').removeClass('cart-body-section-visible');

      if ($('.empty-cart-body-saved-items').length) {
        $('.empty-cart-body-saved-items').removeClass('d-none');
        $('.empty-cart-body-cart').addClass('d-none');
        $('.cart-body').addClass('d-none');
        $('.cart-bottom-summary').addClass('d-none');
        if ($('.empty-cart-body-cart').length ==0) {
          $('.cart-mobile-total').removeClass('d-none');
        } else {
          $('.cart-mobile-total').addClass('d-none');
        }
      } else {
        $('.empty-cart-body-saved-items').addClass('d-none');
        $('.empty-cart-body-cart').addClass('d-none');
        $('.cart-body').removeClass('d-none');
        $('.cart-bottom-summary').addClass('d-none');

        if ($('.empty-cart-body-cart').length ==0) {
          $('.cart-mobile-total').removeClass('d-none');
        } else {
          $('.cart-mobile-total').addClass('d-none');
        }
      }
    } else {
      $('.cart-body-cart-section').removeClass('cart-body-section-visible');
      $('.cart-body-saved-items-section').addClass('cart-body-section-visible');

        if ($('.empty-cart-body-cart').length) {
          $('.empty-cart-body-cart').removeClass('d-none')
          $('.empty-cart-body-saved-items').addClass('d-none')
          $('.cart-body').addClass('d-none')
          $('.cart-bottom-summary').addClass('d-none');
          $('.cart-mobile-total').addClass('d-none');
        } else {
          $('.empty-cart-body-cart').addClass('d-none')
          $('.cart-body').removeClass('d-none')
          $('.empty-cart-body-saved-items').addClass('d-none')
          $('.cart-bottom-summary').removeClass('d-none');
          $('.cart-mobile-total').removeClass('d-none');
        }
      }
  });

  if ($('.empty-cart-body-saved-items').length || $('.empty-cart-body-cart').length) {
    $('.cart-body').addClass('d-none');
    $('.cart-bottom-summary').addClass('d-none');
    $('.cart-mobile-total').addClass('d-none');

  }

  $('cart_v2_remove_hoses').on('click',function() {
    $('.product-footer-custom-hose').find('.line_item_quantity').val(0);
    $('.product-footer-custom-hose').parents('form').first().submit();
  });

  $(document).on("keyup", ".promo-input-field", function(e) {
    if ($(this).val()) {
      $('.promo-apply').css('color','var(--palette-neutral-900)');
      $('.promo-apply').css('cursor','pointer');
    } else {
      $('.promo-apply').css('color','var(--palette-neutral-300)');
      $('.promo-apply').css('cursor','default');
    }
  });

  if( $('.ticker:visible').length ) {
    setTimeout(function() {
      $('.ticker').hide();
    }, 4000);
  }

  $('.hose-delete-modal-button').attr('data-remote','true');

  $(".line_item_quantity").keypress(function(e) {
    var code = e.keyCode || e.which;

    if(code == 13) {
      if($(this).attr('max') == '' || parseInt($(this).val()) <= parseInt($(this).attr('max'))) {
        $(this).parents('form').submit();
      }
    }
  });

  $('.promo-input-field').on('keyup', function(event) {
    if(event.keyCode != 13) {
      remove_border();
    }
  });

  function remove_border() {
    $('.cart-bottom-summary-promo').find('.promo-input-field').css('border','0px')
    $('.cart-body-summary-promo').css('border','0px')
    $('.cart-summary-promo-helper').addClass('d-none')
  }
});


# touched on 2025-05-22T21:19:10.146186Z
# touched on 2025-05-22T22:38:42.253044Z
# touched on 2025-05-22T22:47:16.879248Z
# touched on 2025-05-22T23:01:55.564165Z
# touched on 2025-06-13T21:16:48.422131Z