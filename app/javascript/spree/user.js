document.addEventListener("turbolinks:load", () => {

  if($('.users.show, .user_sessions.new, .early-bird-login-modal, .user_sessions.create, .user_registrations.new, .user_registrations.create, .checkout.edit, .checkout-login-modal, .subscriber-login-modal, .user_passwords.edit').length) {

    const regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;

    $('.checkout-login-modal').on('show.bs.modal', function () {
      disablePageScroll();
    });

    $('.checkout-login-modal').on('hide.bs.modal', function () {
      enablePageScroll();
    });


    $('.subscriber-login-modal, .early-bird-login-modal').on('show.bs.modal', function () {
      $(this).addClass('show-subscriber-modal').removeClass('hide-subscriber-modal');
      disablePageScroll();
    });

    $('.subscriber-login-modal, .early-bird-login-modal').on('hide.bs.modal', function () {
      enablePageScroll();
      $(this).addClass('hide-subscriber-modal').removeClass('show-subscriber-modal');

      if($('.success-bg, .early-success-bg').length) {
        location.reload();
      }
    });

    function disablePageScroll() {
      if(!$('.checkout.edit').length) {
        $('body').addClass('ag-modal-open');
      }
    }

    function enablePageScroll() {
      $('body').removeClass('ag-modal-open');
    }

    if($('.flatpickr').length) {
      $('[data-tooltip-display="true"]').tooltip(),
      flatpickr("[class='flatpickr']", {
         mode: "range"
      });
    }

    if($('.visit-thank-sign-in-user').length) {
      $('.thank-sign-in-user').modal('show');
      $('.thank-sign-in-user').removeClass('visit-thank-sign-in-user')
    }

    if($('.linked-with-existing-account').length) {
      $('.linked-with-existing-account').modal('show');
    }

    $(document).on('click', '#agree_policy', function() {
      $('.agree-policy-error').html('');
    });

    $('#editUser').on('show.bs.modal', function (event) {
      var button = $(event.relatedTarget);
      var email = button.data('whatever');
      var modal = $(this);
      modal.find('.modal-body #email').val(email).css('font-family', 'Poppins');
    });

    $(document).on('click', '#password-icon, #login_password-icon, #confirm-password-icon, #login_password_icon', function (e) {
      const element = $(e.currentTarget);
      const parent = $('#' + $(element).attr('data-field'));
      const type = $(parent).attr('type') === 'password' ? 'text' : 'password';
      $(parent).prop('type', type);
      if (type === 'text' && $(element).hasClass("secure-password")) {
        $(element).addClass('show-secure-password').removeClass('secure-password');
      } else if (type === 'password' && $(element).hasClass("show-secure-password")) {
        $(element).addClass('secure-password').removeClass('show-secure-password');
      }
    });

    $(document).on('click', '#nav-continue-btn', function () {
      const nav_login_email = $('#nav_login_email');
      const nav_login_email_value = nav_login_email.val();

      if ( !regex.test( nav_login_email_value ) || nav_login_email_value.length == '') {
        $('.email-message').addClass('error-data').show();
        nav_login_email.parent().addClass('error-field');
        $(this).prop('disabled', true);
      }
    });

    $(document).on('input', '#nav_login_email', function(){
      if (regex.test($('#nav_login_email').val())) {
        $('.email-message').removeClass('error-data').hide();
        $('#nav_login_email').parent().removeClass('error-field');
        $('#nav-continue-btn').prop('disabled', false);
      }
    });

    $(document).on('click', '#nav-login-btn', function () {
      if($('#nav_login_password').length) {
        const login_password = $('#nav_login_password');
        const login_password_value = login_password.val();

        if ( login_password_value.length == '' || login_password_value.length <= 5) {
          $('#nav_login_pass_message').addClass('error-data').html('Password lenght is less than 6').show();
          login_password.parent().addClass('error-field');
          $(this).prop('disabled', true);
        }
      }
    });

    $(document).on('input', '#nav_login_password', function(){
      if($('#nav_login_password').val().length >= 6) {
        $('#nav_login_password').parent().removeClass('error-field');
        $('#nav_login_pass_message').removeClass('error-data').html('').hide();
        $('#nav-login-btn').prop('disabled', false);
      }
    });

    $(document).on('input', '#password, #confirm-password', function(){
      if ($('#confirm-password').val() == $('#password').val()) {
        $('#confirm-pass-message').removeClass('error-data').hide();
        $('#password').parent().removeClass('error-field');
        $('#confirm-password').parent().removeClass('error-field');
        $('#create-account, #update-password-btn').prop('disabled', false);
      } else if($('#confirm-password').val().length >= 6 && $('#password').val().length >= 6) {
        $('#confirm-password').parent().removeClass('error-field');
        $('#password').parent().removeClass('error-field');
        $('#confirm-pass-message').removeClass('error-data').hide();
        $('#create-account, #update-password-btn').prop('disabled', false);
      }
    });

    $(document).on('click', '#subscribe', function() {
      const signup_email = $('#signup-email');
      const signup_email_value = signup_email .val();
      const password_field = $('#subs-password');
      const pf_value = password_field .val();
      const confirm_password_field = $('#subs-confirm-password');
      const cpf_value = confirm_password_field .val();
      var agree_to_policy = $('#agree_to_policy:visible').length ? $('#agree_to_policy:checked').length : true

      if (!regex.test( signup_email_value ) && signup_email_value.length != '') {
        $('#subscriber-email-message').addClass('error-data').html('Please enter a valid email address').show();
        signup_email.parent().addClass('error-field');
        password_field.parent().removeClass('error-field');
        confirm_password_field.parent().removeClass('error-field');
        $('#subscriber-password-message').removeClass('error-data').hide();
        $('#subscriber-policy-message').removeClass('error-data').hide();
        $(this).prop('disabled', true);
      } else if ( $('#subscriber-email-message').hasClass('error-data') ) {
        $(this).prop('disabled', true);
      } else if ( pf_value.length <= 5 && pf_value.length != '' ) {
        $('#subscriber-password-message').addClass('error-data').html('Password is too short (minimum is 6 characters)').show();
        password_field.parent().addClass('error-field');
        $('#subscriber-policy-message').removeClass('error-data').hide();
        $(this).prop('disabled', true);
      } else if ( cpf_value.length <= 5 &&  cpf_value.length != '') {
        $('#subscriber-password-message').addClass('error-data').html('Password is too short (minimum is 6 characters)').show();
        confirm_password_field.parent().addClass('error-field');
        $('#subscriber-policy-message').removeClass('error-data').hide();
        $(this).prop('disabled', true);
      } else if ((pf_value != cpf_value) && (pf_value.length > 5) && (cpf_value.length !='')) {
        $('#subscriber-password-message').addClass('error-data').html('Passwords do not match').show();
        password_field.parent().addClass('error-field');
        $('#subscriber-password-message').addClass('error-data').html('Passwords do not match').show();
        confirm_password_field.parent().addClass('error-field');
        $('#subscriber-policy-message').removeClass('error-data').hide();
        $(this).prop('disabled', true);
      } else if(!agree_to_policy) {
        $('#subscriber-policy-message').addClass('error-data').html('You must agree to our Privacy Policy').show();
        $(this).prop('disabled', true);
      }
    });

    $(document).on('input', '#signup-email', function(){
      if (regex.test($('#signup-email').val())) {
        $('#subscriber-email-message').removeClass('error-data').hide();
        $('#signup-email').parent().removeClass('error-field');
        $('#subscribe').prop('disabled', false);
      }
    });

    $(document).on('input', '#subs-password, #subs-confirm-password', function(){
      if ($('#subs-confirm-password').val() == $('#subs-password').val()) {
        $('#subscriber-password-message').removeClass('error-data').hide();
        $('#subs-password').parent().removeClass('error-field');
        $('#subs-confirm-password').parent().removeClass('error-field');
        $('#subscribe').prop('disabled', false);
      } else if($('#subs-confirm-password').val().length >= 6 && $('#subs-password').val().length >= 6) {
        $('#subs-confirm-password').parent().removeClass('error-field');
        $('#subs-password').parent().removeClass('error-field');
        $('#subscriber-password-message').removeClass('error-data').hide();
        $('#subscribe').prop('disabled', false);
      }
    });

    $(document).on('click', '#agree_to_policy', function() {
      $('#subscriber-policy-message').removeClass('error-data').hide();
      $('#subscribe').prop('disabled', false);
    });

    $(document).on('click', '#create-account, #update-password-btn', function() {
      const password_field = $('#password');
      const pf_value = password_field .val();
      const confirm_password_field = $('#confirm-password');
      const cpf_value = confirm_password_field .val();
      var agree_policy = $('#agree_policy:visible').length ? $('#agree_policy:checked').length : true

      if ( pf_value.length <= 5 && pf_value.length != '' ) {
        confirm_password_field.parent().next().addClass('error-data').html('Password is too short (minimum is 6 characters)').show();
        password_field.parent().addClass('error-field');
        $(this).prop('disabled', true);
      } else if ( cpf_value.length <= 5 &&  cpf_value.length != '') {
        confirm_password_field.parent().next().addClass('error-data').html('Password is too short (minimum is 6 characters)').show();
        confirm_password_field.parent().addClass('error-field');
        $(this).prop('disabled', true);
      } else if ((pf_value != cpf_value) && (pf_value.length > 5) && (cpf_value.length !='')) {
        $('#pass-message').addClass('error-data').html('Passwords do not match').show();
        password_field.parent().addClass('error-field');
        $('#confirm-pass-message').addClass('error-data').html('Passwords do not match').show();
        confirm_password_field.parent().addClass('error-field');
        $(this).prop('disabled', true);
      } else if(!agree_policy) {
        $('.agree-policy-error').html('You must agree to our Privacy Policy');
        $(this).prop('disabled', true);
      } else if($('.show-subscriber').length) {
        var agree_to_policy = $('#agree_to_policy:visible').length ? $('#agree_to_policy:checked').length : true
        if(!agree_to_policy && pf_value.length != '' && cpf_value.length != '') {
          $(this).prop('disabled', true);
        }
      }

      if ( pf_value.length == '' && cpf_value.length == '') {
        confirm_password_field.parent().next().removeClass('error-data').html('').hide();
        confirm_password_field.parent().removeClass('error-field');
        $(this).prop('disabled', false);
      }
    });

    $(document).on('click', '.privacy-policy', function() {
      var agree_policy = $('#agree_policy:visible').length ? $('#agree_policy:checked').length : true
      if(agree_policy) {
        $('#create-account').prop('disabled', false);
      }
    })
  }

  if ($('.checkout.update_registration').length) {
    $('#order_email').on('input', function() {
      if ($(this).parent().next().css('display') == 'block') {
        $('#guest_error_message').css('display', 'none');
      }
    })
  }
});

# touched on 2025-05-22T19:22:24.132722Z
# touched on 2025-05-22T20:44:20.959336Z
