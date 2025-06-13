$(document).on('turbolinks:load', function(event) {
  window.get_jquery_object = get_jquery_object;
  window.quantity_changer_modal = quantity_changer_modal;

  if( $('.checkout.edit').length ) {
    $(document).on('click','#add-coupon-code', {} ,function() {
      if (this.dataset.operation == 'cancel' && $('#promo-field').hasClass('promo-error-field'))
      {
        remove_error_state();
        show_promo_link();
        $('#add-coupon-code').removeClass('success');
      }
      else if (this.dataset.operation == 'cancel') {
        show_promo_link();
      }
      else {
        $('#hidden-coupon-code').val($('#promo-field').val());
      }
    });

    $(document).on('click','.promo-link', {} ,function() {
      $('.promo-container').hide();
      $('#promo-field-block').removeClass('d-none');
      $('#promo-field').focus();
    });

    $(document).on('input keypress','#promo-field', {} ,function(e) {

      if(e.keyCode == 13) {
        $('#promo-field').blur();
      }

      if ($('#promo-field').val() == "") {
        $('#add-coupon-code').html('Cancel');
        $('#add-coupon-code').attr('data-operation', 'cancel');
      }
      else {
        $('#add-coupon-code').html('Apply');
        $('#add-coupon-code').attr('data-operation', 'apply');
      }
    });

    $(document).on('click','#promo-field', {} ,function() {
      if ($('#promo-field').hasClass('promo-error-field')) {
        remove_error_state();
      }
      $('#add-coupon-code').removeClass('success');
    });

    $(document).on('click','#flip, .order-detail-section, .close-summary-modal, .checkout-cart-preview-mbl', {} ,function() {
      $(document).width() < 768 && show_mobile_summary_modal();
    });

    $(document).scroll(function() {
      if($(document).width() < 768) {
        checkout_summary_on_summay();
      }
    });

    $('.checkout-email-field').on('focusout', function(e) {
      $('#hidden-email').val($(this).val());
      $('#guest-member-login').click();
    });

    $('#checkout_form_registration').on('submit', function() {
      $(this).find(':submit').attr('disabled', true);
    });

    $('.checkout-email-field').on('input', function(e) {
      $('#guest-member-login').attr('disabled', false);
    });

    var show_mobile_summary_modal = function() {
      if($('.show-summary-modal').length) {
        $('.cart-detail-body').removeClass('show-summary-modal');
        $('.checkout-modal-back-drop').removeClass('active-back-drop');
        $('#flip').show();
        $('.close-summary-modal').hide();
        $('.checkout.edit').removeClass('ag-modal-open');
        checkout_summary_on_summay();
      }
      else {
        $('.cart-detail-body').addClass('show-summary-modal');
        $('.checkout-modal-back-drop').addClass('active-back-drop');
        $('.order-detail-section').hide();
        $('#flip').hide();
        $('.close-summary-modal').show();
        $('.checkout.edit').addClass('ag-modal-open');
        checkout_summary_on_summay();
      }
    };

    var checkout_summary_on_summay = function(element) {
      var window_scroll = $(this).scrollTop();
      var product_preview = $('.qty-badge').offset().top;
      if (window_scroll > product_preview && !$('.show-summary-modal').length) {
        $('.order-detail-section').show();
        $('#flip').hide();
      } else if ($('.show-summary-modal').length){
        $('#flip').hide();
      } else {
        $('.order-detail-section').hide();
        $('#flip').show();
      }
    };

    $(document).on('click','.close-checkout-qty-modal', function () {
      $('.quantity-modal-drop-down').removeClass('active-qty-modal-backdrop');
    });

    $(document).on('hide.bs.modal','#checkout-quantity-modal', function () {
      $('.quantity-modal-drop-down').removeClass('active-qty-modal-backdrop');
    });

    $(document).on('click', '#continue-to-login', function() {
      $('.checkout-registration-modal').modal('hide');
    });
  }
});

function get_jquery_object() {
  window.$ = $;
}

function quantity_changer_modal() {
  $('.quantity-changer-modal').modal('toggle');
  if($(document).width() < 768) {
    $('.quantity-modal-drop-down').addClass('active-qty-modal-backdrop');
    $('.modal-backdrop.show').hide();
    $('.checkout-quantity-changer-modal').addClass('show-quantity-modal');
  }
}

function remove_error_state() {
  $('#promo-field').removeClass('promo-error-field');
  $('.promo-error').hide();
  $('.promo-error').html("");
  $('#promo-field').val("");
  $('#add-coupon-code').removeClass('promo-error-button');
}

function show_promo_link() {
  $('#promo-field-block').addClass('d-none');
  $('.promo-container').show();
}

# touched on 2025-05-22T19:19:59.854636Z
# touched on 2025-05-22T22:51:11.793183Z
# touched on 2025-05-22T23:06:01.613553Z
