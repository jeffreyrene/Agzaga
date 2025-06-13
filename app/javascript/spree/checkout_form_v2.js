$(document).on('turbolinks:load', function(event) {
  checkout_js(event);
  window.checkout_js = checkout_js;
});

function perform_sorting(attribute, order) {
  var sorted_chapters;
  if(order == 'asc') {
    sorted_chapters = $('.chapter-row').sort(function(a, b) {
      return String.prototype.localeCompare.call($(a).data(attribute).toString().toLowerCase(), $(b).data(attribute).toString().toLowerCase());
    });
  }
  else if(order == 'desc') {
    sorted_chapters = $('.chapter-row').sort(function(a, b) {
      return String.prototype.localeCompare.call($(b).data(attribute).toString().toLowerCase(), $(a).data(attribute).toString().toLowerCase());
    });
  }
  return sorted_chapters;
}

function checkout_js(event) {
  if( $('.checkout.edit').length || $('.orders.show').length || $('.pages.chuckwagon_dvd').length ) {
    $('#ffa-chapter-search-input').on('input', function() {
      if ( $(this).val().length == 0 ) {
        $('.chapter-row').show();

      } else {
        var search_str = $(this).val().toLowerCase();;
        $('.chapter-row').show();

        $('#chapter-list-table').find('.chapter-row').each( function() {
          ($(this).find('.school-name').text().trim().toLowerCase().includes(search_str) ||
          $(this).find('.state-name').text().trim().toLowerCase().includes(search_str)) !== true && $(this).hide();
        });
      }
    });

    $('#sort-chapter').on('click', function() {
      var toggle_order = $(this)[0].dataset.order == 'desc' ? 'asc' : 'desc';
      var sorted_chapters = perform_sorting('chapter', $(this)[0].dataset.order);
      $(this)[0].dataset.order = toggle_order;
      $(this).find("img").removeClass().addClass("icon-"+toggle_order);
      var table = $("#chapter-list-table");
      $('.chapter-row').each(function() {
        $(this).remove();
      });
      sorted_chapters.each(function() {
        table.append($(this));
      });
    });

    $('#sort-state').on('click', function() {
      var toggle_order = $(this)[0].dataset.order == 'desc' ? 'asc' : 'desc';
      var sorted_chapters = perform_sorting('state', $(this)[0].dataset.order);
      $(this)[0].dataset.order = toggle_order;
      $(this).find("img").removeClass().addClass("icon-"+toggle_order).addClass("float-right");
      var table = $("#chapter-list-table");
      $('.chapter-row').each(function() {
        $(this).remove();
      });
      sorted_chapters.each(function() {
        table.append($(this));
      });
    });

    if ($('.custom-field').length) {
      $(".custom-field-input").each(function() {
        if ($(this).val() != '') {
          $(this).siblings(".placeholder").css('display', 'none');
          $(this).addClass('check-image')
        }
        else {
          $(this).siblings(".placeholder").css('display', 'block');
          $(this).css('border-color', 'none');
          $(this).css('background-image', 'none');
          $(this).removeClass('check-image');
        }
      });

      $('.selected-chapter-btn').find('.chapter-selected-icon').hide();
      $('.active-chapter').find('.chapter-selected-icon').show();

      $(document).on('click','.chapter-row', {} ,function(e){
        $(this).find('input[type="radio"]').prop('checked', true);
        $('.selected-chapter-btn').removeClass('chapter-selected-btn');
        $('.selected-chapter-btn').addClass('chapter-select-btn');
        $('.chapter-row').removeClass('active-row');
        $(this).addClass('active-row');
        $(this).find('.selected-chapter-btn').addClass('chapter-selected-btn').removeClass('chapter-select-btn');
      });

       $(document).on('click','.chapter-apply-btn', {} ,function(e){
        $('.selected-chapter-btn').removeClass('active-chapter');
        $('.selected-chapter-btn').find('.chapter-selected-icon').hide();
        $('.chapter-selected-btn').addClass('active-chapter');
        $('.active-chapter').find('.chapter-selected-icon').show();
        $('.chapter-row').removeClass('active-selected-row');
        $('.active-row').addClass('active-selected-row');
        $('#cart_chapter_selection_modal').modal('hide');
      });

      $('#cart_chapter_selection_modal').on('hide.bs.modal', function () {
        $('.selected-chapter-btn').removeClass('chapter-selected-btn');
        $('.selected-chapter-btn').addClass('chapter-select-btn');
        $('.active-chapter').removeClass('chapter-select-btn');
        $('.active-chapter').addClass('chapter-selected-btn');
        $('.selected-chapter-btn').prev().prop('checked', false);
        $('.active-chapter').prev().prop('checked', true);
        $('.chapter-row').removeClass('active-row');
        $('.active-selected-row').addClass('active-row');
      });

      $(document).on('click','.cart-chapter-remove-btn', {} ,function(e){
        $('.selected-chapter-btn').removeClass('chapter-selected-btn');
        $('.selected-chapter-btn').removeClass('active-chapter');
        $('.selected-chapter-btn').addClass('chapter-select-btn');
        $('.selected-chapter-btn').prev().prop('checked', false);
        $('.selected-chapter-btn').find('.chapter-selected-icon').hide();
        $('.chapter-row').removeClass('active-row');
        $('.chapter-row').removeClass('active-selected-row');
      });

      $(document).on('focusin','#coupon_code' ,function() {
        $('.invalid-promo').css('display', 'none');
        $('.input-coupon-code').removeClass('active_promo_code');
        $('.input-coupon-code').css({'border-color': '#DADADA', 'background-image': 'none'})
      });

      $(document).on('focusout','#coupon_code' ,function() {
        $(this).addClass('active_promo_code');
        $('.active_promo_code').removeClass('check-image');
      });

      $(document).on('focusout input', '.custom-field-input', function() {
        checkout_validation($(this));
      });

      $('.custom-field-input').focusin(function() {
        var error_field = $(this).attr('id').replace('field','error');
        $(this).css('border-color', '#1E1E1E')
        $(this).siblings("."+ error_field).css('display', 'none');
        $(this).siblings(".placeholder").css('display', 'block');
        $(this).siblings('.zipcode-error').css('display', 'none');
        $(this).siblings('.phone-error').css('display', 'none');
      });
    }

    $('.address-field').on('click', function() {
      $('.address-line').css('display', 'block');
      $('.address-field').css('display', 'none');
    });


    if( $('#bfirstname-field').length && $('#bfirstname-field').val().length == 0) {
      $('#bfirstname-field').focus();
      $('html,body').scrollTop(0);
    }

    $('#order_use_billing').on('click', function(){
      if (document.getElementById('order_use_billing').checked) {
        $("#bfirstname-field").focus();
        $("#bfirstname-field").siblings('.invalid-feedback').css('display', 'none');
      }
      else {
        setTimeout(function() {
          $('#sfirstname-field').focus();
          $("#sfirstname-field").siblings('.invalid-feedback').css('display', 'none');
        }, 100);
      }
    });

    var order_use_shipping = $('input[name="order[use_shipping]"]');
    order_use_shipping.change(function() {
      update_billing_form_state(order_use_shipping);
      checkValidInput();
    });

    var checkout_validation = function(element) {
      var address_type = element.parent().data('address');
      if (element.val() == '' && (element[0].hasAttribute('required') || element.hasClass('states-drop-down'))) {
        element.addClass('check-validation');
        element.parent().css('border-color', '#F63939');
        element.parent().removeClass('top-border-none');
        element.siblings('.ag-input-icon-append').show();
        RequiredFieldsErrorMessage('required-field-error', 'Please fill required fields.', address_type )
      }
      else {
        element.removeClass('check-validation');
        element.parent().css('border-color', '#DADADA');
        if(!['sfirstname', 'slastname', 'blastname', 'bfirstname', 'card_number', 'email', 'order_pick_up_person_attributes_firstname'].includes(element.attr('id'))) {
          element.parent().addClass('top-border-none');
        }
        $('.payment-card-errors').empty();
        element.siblings('.ag-input-icon-append').hide();
      }
      if(element.val() != '' && (element[0].hasAttribute('required') || element.hasClass('states-drop-down'))) {
        var current_field = '#required-field-error';
        element.parent().removeClass('required-field');
        if(!$('.required-field').length) {
          var parent_field = $(".error-messages-section." + address_type);
          removeErrorMessage(parent_field, current_field);
        }
      }
      if (element.parent().hasClass('email-validation')) {
        var field_id = $('#' + element.attr('id'));
        if (element.val() != '' ) {
          element.siblings('.invalid-feedback').addClass('email-error');
          checkEmailValidation(field_id, 'email-error-message')
        } else if(element.val() == '') {
          var parent_field = $('.email-error-message');
          var current_field = field_id.attr('id');
          displayCheckoutErrorMessage(parent_field, current_field, 'Please Enter a valid Email Address.');
        }
      }
      else if(element.parent().hasClass('pick-up-person-email-validation')) {
        var field_id = $('#' + element.attr('id'));
        if (element.val() != '' ) {
          element.siblings('.invalid-feedback').addClass('email-error');
          checkEmailValidation(field_id, 'pick-up-error-message')
        } else if(element.val() == '') {
          var parent_field = $('.pick-up-error-message');
          var current_field = field_id.attr('id');
          displayCheckoutErrorMessage(parent_field, current_field, 'Please Enter a valid Email Address.');
        }
      }
      else if (element.parent().hasClass('zip-validation')) {
        var field_id = $('#' + element.attr('id'));
        checkZipcode(element, field_id, address_type);
      }

      else if (element.parent().hasClass('phone-validation')) {

        var field_id = $('#' + element.attr('id'));
        checkPhone(element, field_id, address_type);
      }
      checkValidInput()
    }

    var update_billing_form_state = function(order_use_shipping) {
      if (order_use_shipping.is(":checked")) {
        $("#billing-address-fields").hide();
        $("#billing-address-fields .inner input, #billing-address-fields .inner select").prop(
          "disabled",
          true
        );
      } else {
        $("#billing-address-fields").show();
        $("#billing-address-fields .inner input, #billing-address-fields .inner select").prop(
          "disabled",
          false
        );
      }
    };

    update_billing_form_state(order_use_shipping);

    if ( $('input[name="order[ship_address_attributes][phone]"]' ).length > 0) {
      new Cleave( $('input[name="order[ship_address_attributes][phone]"]' ), {
        numericOnly: true,
        delimiters: ["-", "-"],
        blocks: [3, 3, 4]
      });
    }

    if ( $('input[name="order[bill_address_attributes][phone]"]' ).length > 0) {
      new Cleave( $('input[name="order[bill_address_attributes][phone]"]' ), {
        numericOnly: true,
        delimiters: ["-", "-"],
        blocks: [3, 3, 4]
      });
    }

    function nameFieldValidation (current_field, field_id, field_error) {
      var field_id = $('#' + field_id)
      var parent_id = current_field.parent();
      if (!((parent_id).find('.' + field_error).length) && current_field.siblings(".invalid-feedback").css("display") == "none") {
        displayErrorMessage(field_error, 'Only alphabets are allowed', parent_id)
      }
      var field_message = $('.' + field_error)
      checkNameValidation(current_field, field_id, field_message)
    }

    function checkValidInput() {
      if ($("input.check-validation:not(:disabled)").length) {
        $(this).removeClass('check-image');
        $('.pay-now-btn').addClass('disable-save-btn')
        $('.pay-now-btn').prop('disabled', true);
        $('#shipping-edit, #billing-edit').prop('disabled', true).css('cursor', 'default');
      }
      else {
        $('.pay-now-btn').removeClass('disable-save-btn')
        $('.pay-now-btn').prop('disabled', false);
        $('#shipping-edit, #billing-edit').prop('disabled', false).css('cursor', 'pointer');
      }
    }

    function checkEmailValidation(field_id, parent_field) {
      const regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
      if (!regex.test( field_id.val() ) && field_id.val() != '') {
        $('.email-error').css('display', 'block');
        field_id.parent().css('border-color', '#F63939');
        field_id.parent().removeClass('top-border-none');
        field_id.removeClass('check-image');
        parent_field = $('.' + parent_field);
        var current_field = field_id.attr('id');
        field_id.addClass('check-validation');
        displayCheckoutErrorMessage(parent_field, current_field, 'Please Enter a valid Email Address.')
      }
      else {
        $('.email-error').css('display', 'none');
        field_id.parent().css('border-color', '#DADADA');
        field_id.addClass('check-image');
        field_id.removeClass('check-validation');
        parent_field = $('.' + parent_field);
        var current_field = '#' + field_id.attr('id');
        removeErrorMessage(parent_field, current_field);
      }
      checkValidInput()
    }

    function checkNameValidation(current_field, field_id, field_message) {
      const regex = /^[a-zA-Z ]*$/
      field_id.addClass('check-image');

      if (regex.test(field_id.val() ) && field_id.val() != '') {
        field_message.css('display', 'none');
        field_id.css('border-color','#DADADA')
        field_id.addClass('check-image');
      }
      else {
        errorMessage(current_field, field_message)
        field_id.removeClass('check-image');
        field_id.css({'border-color':'#F63939', 'background-image':'none'});
      }
      checkValidInput()
    }

    function checkZipcode(current_field, field_id, address_type) {
      const regex =  /^(\d{5})?$/;

      if (regex.test(field_id.val() ) && field_id.val() != '') {
        field_id.parent().css('border-color','#DADADA')
        field_id.parent().addClass('top-border-none');
        field_id.siblings('.ag-input-icon-append').hide();
        field_id.removeClass('check-validation');
        var current_field = '#' + field_id.attr('id');
        var parent_field = $(".error-messages-section." + address_type);
        removeErrorMessage(parent_field, current_field);
      }
      else {
        field_id.parent().css({'border-color':'#F63939', 'background-image':'none'});
        field_id.parent().removeClass('top-border-none');
        field_id.siblings('.ag-input-icon-append').show();
        field_id.addClass('check-validation');
        var parent_field = $(".error-messages-section." + address_type);
        var current_field = field_id.attr('id');
        displayCheckoutErrorMessage(parent_field, current_field, 'Please enter valid 5-digits zipcode');
      }
      checkValidInput()
    }

    function checkState(current_field, field_id, address_type) {

      if (field_id.val() != '') {
        field_id.parent().css('border-color','#DADADA')
        field_id.parent().addClass('top-border-none');
        field_id.siblings('.ag-input-icon-append').hide();
        field_id.removeClass('check-validation');
        var current_field = '#' + field_id.attr('id');
        var parent_field = $(".error-messages-section." + address_type);
        removeErrorMessage(parent_field, current_field);
        field_id.removeClass('error-class');
        if ($('.error-message:visible').length < 1) {
          $('#payment_step_submit_button').prop("disaled", false).removeClass('disabled').removeClass('disable-save-btn');
        }
      }
      else {
        field_id.parent().css({'border-color':'#F63939', 'background-image':'none'});
        field_id.addClass('error-class');
        field_id.parent().removeClass('top-border-none');
        field_id.siblings('.ag-input-icon-append').show();
        field_id.addClass('check-validation');
        var parent_field = $(".error-messages-section." + address_type);
        var current_field = field_id.attr('id');
        displayCheckoutErrorMessage(parent_field, current_field, 'Please select state from list');
      }
      checkValidInput()
    }

    function checkPhone(current_field, field_id, address_type) {
      const regex =  /^\d{3}-\d{3}-\d{4}$/;

      if (regex.test(field_id.val() ) && field_id.val() != '') {
        field_id.parent().css('border-color','#DADADA')
        field_id.addClass('check-image');
        field_id.parent().addClass('top-border-none');
        field_id.siblings('.ag-input-icon-append').hide();
        field_id.removeClass('check-validation');
        var current_field = '#' + field_id.attr('id');
        var parent_field = $(".error-messages-section." + address_type);
        removeErrorMessage(parent_field, current_field);
      }
      else {
        field_id.removeClass('check-image');
        field_id.parent().css({'border-color':'#F63939', 'background-image':'none'});
        field_id.parent().removeClass('top-border-none');
        field_id.siblings('.ag-input-icon-append').show();
        var parent_field = $(".error-messages-section." + address_type);
        var current_field = field_id.attr('id');
        field_id.addClass('check-validation');
        displayCheckoutErrorMessage(parent_field, current_field, 'Please enter a valid phone number');
      }
      checkValidInput()
    }

    function errorMessage(current_field, field_message) {
      if (current_field.siblings(".invalid-feedback").css("display") == "none") {
        field_message.css('display', 'block');
      }
      else {
        field_message.css('display', 'none');
      }
    }

    function displayErrorMessage(className, message, parentId) {
      $('<div class="'+ className +' invalid-input text-left">'+ message +'</div>').appendTo(parentId);
    }

    function removeErrorMessage(parent_field, current_field) {
      if(parent_field.find(current_field).length) {
        var removeElement = '.error-message' + current_field;
        $(removeElement).remove();
      }
    }

    function displayCheckoutErrorMessage(parent_field, current_field, message) {
      if(!parent_field.find('#' + current_field).length) {
        $('<div class="error-message" id="'+current_field+'">'+ message +'</div>').appendTo(parent_field);
      }
    }

    function RequiredFieldsErrorMessage(field_id, message, address_type) {
      var form = ".error-messages-section." + address_type
      var parent = $(form);
      var current_field = '#' + field_id;
      if(!parent.find(current_field).length) {
        $('<div class="error-message" id="'+field_id+'">'+ message +'</div>').appendTo(parent);
      }
    }

    $(document).on("mouseover", "#subtotal-help, #tax-help, #shipping-help", (event) => {
      $(event.target).tooltip(
      {   html: true,
          trigger: 'manual',
          delay: { "hide": 500 }
      }).tooltip("show");
    });

    var isOver = false;
    $(document).on("mouseleave", "#subtotal-help, #tax-help, #shipping-help", (event) => {
        setTimeout(function () { }, 500);
        if (!isOver)
            setTimeout(function () { $('#subtotal-help, #tax-help, #shipping-help').tooltip('hide'); }, 500);
    });

    $(document).on("mouseover", ".tooltip", (event) => {
        isOver = true;
    });

    $(document).on("mouseleave", ".tooltip", (event) => {
        setTimeout(function () { $('#subtotal-help, #tax-help, #shipping-help').tooltip('hide'); }, 500);
    });

    $(document).on('change', '#order_ship_address_attributes_state_id', (event) => {
      if ($('#order_ship_address_attributes_state_id').val() != '') {
        $('#order_ship_address_attributes_state_id').addClass('black-color')
      }
    })
    if ($(document).width() > 991) {
      $('.states-drop-down').select2({
        placeholder: 'State',
        width: '100%',
        closeOnSelect: true,
        allowClear: true
      }).on('select2:open', function(e){
        $('.select2-search__field').attr('placeholder', 'Search');
        $(this).siblings('select:enabled').select2('open');

        window.setTimeout(function() {
          document.querySelector(".select2-container--open .select2-search__field").focus();
        }, 1000);
      });

      $('.select2.select2-container').on('focusin', function (e) {
        if ( !$('.select2-container--focus').length > 0 ) {
          if (e.originalEvent && $(this).find(".select2-selection--single").length > 0) {
            $(this).siblings('select').select2('open');
            showStatePlaceholder();
          }
        }
      });

      $('.select2.select2-container').on('focusout', function () {
        $('.states-drop-down').trigger('focusout');
      });
    }

    $('.states-drop-down').focusin(showStatePlaceholder);

    function showStatePlaceholder() {
      if ($('.select2-container--open').is(':visible')) {
        $('.placeholder-states').css('display', 'block');
      }
      else {
        $('.placeholder-states').css('display', 'none');
      }
    }

    $('.states-drop-down').focusout(function() {
      if (!$('.select2-container--open').is(':visible')) {
        $('.placeholder-states').css('display', 'none');
      }
    });

    headerDesign($('#collapseDeliveryOptions'), $('.delivery-header'));
    headerDesign($('#collapsePayment'), $('.payment-header'));
    headerDesign($('#collapseOrderReview'), $('.order-header'));

    function headerDesign(section_id, section_header) {
      if (section_id.hasClass('show')) {
        section_header.css('border-radius', '16px 16px 0 0');
      }
      else {
        section_header.css('border-radius', '16px 16px 16px 16px');
      }
    }

    $(document).on('change', '#store-credit-checkbox', function() {
      if(this.checked) {
        $("#store-credit-request-input").prop('disabled', false);
        $("#store-credit-request-input").css('border-color', '#1E1E1E');
        if ($('#store-credit-request-input').val().length > 1) {
          $('.store-credit-section').css('display','flex');
        }
      }
      else {
        $("#store-credit-request-input").prop('disabled', true);
        if ($('#store-credit-request-input').val().length == 1) {
          $('.store-credit-section').css('display','none');
        }
        $("#store-credit-request-input").css('border-color', '#DADADA')
      }
    });

    $('.shipping-radio').on( "change", function() {
      var apply_shipment = $(this).data('shippingId');
      $(apply_shipment)[0].click();
      $(".shipping-address-panel").removeClass("black-border");
      $(this).closest(".shipping-address-panel").addClass('black-border');
    });

    $(document).on('click','.expand-btn, .view-less-btn', {} ,function() {
      $(this).addClass('active')
      if ($('.expand-btn').hasClass('active')) {
        $('.view-less-btn').show();
        $('.expand-btn').hide();
        $(this).removeClass('active')
      }
      else {
        $('.view-less-btn').hide();
        $('.expand-btn').show();
        $(this).removeClass('active')
      }
    });

    $('#shipping-edit, #billing-edit').on('click', function() {
      if ($('[data-hook=shipping_inner]').length || $('[data-hook=billing_inner]').length) {
        var value = $(this)[0].id.replace("-edit", "");
        if ($('.invalid-feedback, .invalid-input, .email-error').is(':visible')) {
          $('#edit_address_flag').val('');
        }
        else {
          $('#edit_address_flag').val(value);
        }
        $("#save-address").click();
      }
    });

    $(document).on('click', '#place-order-section', function(){
      $('#confirm-order-btn').click();
    })

    $(document).on('click', '.payment_step_pay_now_btn', function(){
      $("#stripe-loader").addClass('show-checkout-loader');
      $('.checkout.edit').addClass('checkout-loader-overflow');
    });

    $(document).on('click','#checkout_affirm_payment_btn', function(){
      var uri = $("#affirm_v2_checkout_payload").data("affirm").merchant.user_confirmation_url;
      $("#affirm_v2_checkout_payload").data("affirm").metadata.mode = "modal";
      affirm.checkout($("#affirm_v2_checkout_payload").data("affirm"));
      affirm.checkout.post({
        onSuccess: function(checkout) {
          let postdata = JSON.stringify({ "checkout_token" : checkout.checkout_token});
          $("#affirm-loader").addClass('show-checkout-loader');

          $.ajax({
            url: uri,
            type: "POST",
            data: postdata,
            headers: {
              "Content-Type": "application/json",
              "Accept" : "text/html",
              "Data-Type" : "text/html"
            }
        });

      }});
    });

    checkValidInput();

    $('#order_ship_address_attributes_state_id').on('change focusout ', function () {
      var address_type = $('#order_ship_address_attributes_state_id').parent().data('address');
      var field_id = $('#order_ship_address_attributes_state_id')
      checkState($('#order_ship_address_attributes_state_id'), field_id, address_type);
    });
    $('#payment_step_submit_button').on('click', function(){
      var address_type = $('#order_ship_address_attributes_state_id').parent().data('address');
      var field_id = $('#order_ship_address_attributes_state_id')
      checkState($('#order_ship_address_attributes_state_id'), field_id, address_type);
    });
  }
}

# touched on 2025-05-22T21:34:20.234961Z
# touched on 2025-05-22T22:37:11.360764Z
# touched on 2025-05-22T23:27:41.065143Z
# touched on 2025-05-22T23:29:33.876129Z
