$(document).on('turbolinks:load', function() {
  if( $('.custom_hose_generator.index').length) {
    $('.help-block').css('display','none')
    $('#helpBtn').on('click', function() {
      $('html, body').animate({
        scrollTop: 0
      }, 400);

      $("#helpBtn img").attr("src", $('.help_active_img').attr('src'));
      $('#helpBtn').css("z-index", '1111');

      $('.help-block').css('display','block');

      document.body.style.overflow = 'hidden'

      var helpbtn =  $(document).width() - $('#helpBtn').offset().left - '22' +'px'
      $('#help-information').css({'right': helpbtn, 'z-index': '11' })

      var onebtn =  $(document).width() - $('.color-group').offset().left -'45'+'px'
      $('#number1').css('right', onebtn)

      var twobtn =  $(document).width() - $('.color-group').offset().left -'45'+'px'
      $('#number2').css('right', twobtn)

      var threebtn =  $(document).width() - $('.section-1').offset().left -'40'+'px'
      $('#number3').css('right', threebtn)

      var fourbtn =  $(document).width() - $('.section-4').offset().left -'40'+'px'
      $('#number4').css('right', fourbtn)

      var fifthbtn =  $(document).width() - $('#add_custom').offset().left -'16'+'px'
      $('#number5').css('right', fifthbtn)

      $(window).on('resize', function(){
        var btntop =  $(document).width() - $('#helpBtn').offset().left - '22' +'px'
        $('#help-information').css({'right': btntop, 'z-index': '11' })

        var onebtn =  $(document).width() - $('.color-group').offset().left -'45'+'px'
        $('#number1').css('right', onebtn)

        var twobtn =  $(document).width() - $('.color-group').offset().left -'45 '+'px'
        $('#number2').css('right', twobtn)

        var threebtn =  $(document).width() - $('.section-1').offset().left -'40'+'px'
        $('#number3').css('right', threebtn)

        var fourbtn =  $(document).width() - $('.section-4').offset().left -'40'+'px'
        $('#number4').css('right', fourbtn)

        var fifthbtn =  $(document).width() - $('#add_custom').offset().left -'16'+'px'
        $('#number5').css('right', fifthbtn)
      });
    });

    $('.help-block').on('click',function() {
      $('.help-block').css('display','none')
      $("#helpBtn img").attr("src", $('.help_black_img').attr('src'))
      document.body.style.overflow = 'auto'
    });

    var variant = $('input[name="custom_hose[variant_id]"]')
    variant.each(function(index){
      var variant_name = $(this).parent().first().text().trim();
      var el = $('.custom_hose_data').filter(function(){ return $(this).data().text.includes(variant_name) })
      if (el.data().text.toLowerCase().indexOf("green") >= 0) {
        $('input[name="custom_hose[variant_id]"]')[index].checked = true
        $('input[name="custom_hose1[variant_id]"]')[index].checked = true
      }else if (el.data().text.toLowerCase().indexOf("brown") >= 0) {
        $('input[name="custom_hose[variant_id]"]')[index].checked = false
        $('input[name="custom_hose1[variant_id]"]')[index].checked = false
      }

    })

    $('.form-check input[name="custom_hose1[variant_id]"]').on('click',function() {
      UpdateSubTotal();
      var control_name = $('.form-check input[name="custom_hose1[variant_id]"]')
      ColorSwitch(control_name, 1)
      RadioSwitch(1, '')
      UpdateSubTotal();
    });

    $('.form-check input[name="custom_hose[variant_id]"]').on('click',function() {
      UpdateSubTotal();
      var control_name = $('.form-check input[name="custom_hose[variant_id]"]')
      ColorSwitch(control_name, '')
      RadioSwitch('', 1)
      UpdateSubTotal();
    });

    function RadioSwitch(index, variant_id){
      var id = $('input[name="custom_hose'+index+'[variant_id]"]:checked').val()
      var variant = $('input[name="custom_hose[variant_id]'+variant_id+'"]')
      variant.each(function(){
        if ($(this).val() == id){
          $(this).prop('checked', true);
        }
        else{
          $(this).prop('checked', false);
        }
      })
    }

    function ColorSwitch(control_name, index) {
      ChangeImage(1,'');
      ChangeImage(2,2);
      var label = control_name.parent().first().text().trim();
      var el = $('.custom_hose_data').filter(function(){ return $(this).data().text.includes(label)})
      var id = $('input[name="custom_hose'+index+'[variant_id]"]:checked').val()

      if ($('input[name="custom_hose'+index+'[variant_id]"]').is(':checked') && el.data().id == id){
        if (el.data().text.toLowerCase().indexOf("green") >= 0) {
          $('.hose-image-container').removeClass('brownmulch')
          $('.hose-image-container').addClass('zillagreen')
        }else if (el.data().text.toLowerCase().indexOf("brown") >= 0){
          $('.hose-image-container').removeClass('zillagreen')
          $('.hose-image-container').addClass('brownmulch')
        }
      }
      else if ($('input[name="custom_hose'+index+'[variant_id]"]').is(':checked') && el.next().data().id == id){
        if (el.next().data().text.toLowerCase().indexOf("green") >= 0) {
          $('.hose-image-container').removeClass('brownmulch')
          $('.hose-image-container').addClass('zillagreen')
        }else if (el.next().data().text.toLowerCase().indexOf("brown") >= 0){
          $('.hose-image-container').removeClass('zillagreen')
          $('.hose-image-container').addClass('brownmulch')
        }
      }
      else {
        $('.hose-image-container').css('background', '#FFFFFF')
      }
    }

    $('.custom_length, .custom_length_mob').focusin(function() {
      $('.custom_length, .custom_length_mob').addClass('input-hover')
      $('.input-group-append').addClass('input-hover');

    });

    $('.custom_length, .custom_length_mob').focusout(function() {
      $('.custom_length, .custom_length_mob').removeClass('input-hover')
      $('.input-group-append').removeClass('input-hover');
    });

    $('input[name="fitting_1_material"]').on('click', function() {
      SyncFittingImages(2,1);
      ChangeImage(1,'');
      ChangeImage(2,2);
    });

    $('input[name="fitting_2_material"]').on('click', function() {
      SyncFittingImages(1,2);
      ChangeImage(2,2);
      ChangeImage(1,'');
    });

    $('.custom_length, .custom_length_mob').on('input', function() {
      $('.custom_length, .custom_length_mob').removeClass('input-error');
      $('.input-group-append').removeClass('input-error');
      if ($('.custom_length').is(':visible')) {
        $('.custom_length_mob').val($('.custom_length').val());
      }else {
        $('.custom_length').val($('.custom_length_mob').val());
      }
      SectionError('none');
      EnableAddtoCart();
      UpdateSubTotal();
    });

    $('input[name="fitting_1_flexRadioDefault"]').on('click',function() {
      $('.block1 .error-message-fitting').css('display', 'none');
      CheckOutOfStock(1,'');
      EnableAddtoCart();
      ChangeImage(1,'');
    });

    $('input[name="fitting_2_flexRadioDefault2"]').on('click',function() {
      $('.block2 .error-message-fitting').css('display', 'none');
      CheckOutOfStock(2,2);
      EnableAddtoCart();
      ChangeImage(2,2);
    });

    $('.add-to-cart').on('click', function() {
      var length;
      if ( $('.custom_length_mob').is(':visible') ) {
        length = $('.custom_length_mob');
      }
      else {
        length = $('.custom_length');
      }

      if (length.val() == "") {
        $('.custom_length, .custom_length_mob').addClass('input-error')
        $('.input-group-append').addClass('input-error');
        SectionError('block');
        DisableAddtoCart('block');
      }

      if (! $('input[name="custom_hose[variant_id]"]').is(':checked')){
        $('.radio-feild').addClass('error-radio')
        SectionError('block');
        DisableAddtoCart('block');
      }

      if (! $('input[name="fitting_1_material"]').is(':checked')) {
        $('input[name="fitting_1_material"]').next().addClass('error-border')
        AddBlockError(1);
      }

      if (! $('input[name="fitting_2_material"]').is(':checked') ) {
        $('input[name="fitting_2_material"]').next().addClass('error-border')
        AddBlockError(2);
      }

      if (! $('input[name="fitting_1_flexRadioDefault"]').is(':checked') ) {
        $('.radio-group').addClass('radio-group-error')
        AddBlockError(1);
      }

      if (! $('input[name="fitting_2_flexRadioDefault2"]').is(':checked') ) {
        $('.radio-group1').addClass('radio-group-error')
        AddBlockError(2);
      }
    });

    $('input[name="custom_hose[variant_id]"]').on('click',function() {
      $('.radio-feild').removeClass('error-radio')
      SectionError('none')
      EnableAddtoCart();
    });

    $('input[name="fitting_2_flexRadioDefault2"]').on('click',function() {
      RemoveFittingTypeError(1, 2);
      UpdateVariantId(2);
    });

    $('input[name="fitting_1_flexRadioDefault"]').on('click',function() {
      RemoveFittingTypeError('', 1);
      UpdateVariantId(1);
    });

    function UpdateSubTotal() {
      var sub_tottal = 0;
      var fitting_1_price = parseFloat($('#fitting_1_price').text().split('$')[1]);
      var fitting_2_price = parseFloat($('#fitting_2_price').text().split('$')[1]);
      var assembly_fee = parseFloat($('#assembly_fee').text().split('$')[1]);
      var length;
      if ( $('.custom_length_mob').is(':visible') ) {
        length = $('.custom_length_mob');
      }
      else {
        length = $('.custom_length');
      }

      var color = $('input[name="custom_hose[variant_id]"]:checked').prev().data('text');
      var length_price = 0;
      if (color != undefined ) {
        length_price = $('.custom_hose_data').filter(function(){ return $(this).data().text.includes(color)}).data('text').split(',').slice(-1);
      }

      if(parseInt(length.val()) > 249) {
        length.val(249);
        if ($('input[name="custom_hose[variant_id]"]').is(':checked')) {
          var price =  length_price * parseInt(length.val());
          $('#hose_price').text('$'+price.toFixed(2));
          sub_tottal = fitting_2_price + fitting_1_price + price;
        }
        else {
          sub_tottal = fitting_2_price + fitting_1_price
        }

        if ($('.custom_length').is(':visible')) {
          $('.custom_length_mob').val($('.custom_length').val());
        }
      }
      else if(parseInt(length.val()) < 0) {
        $(length).val(0);
        sub_tottal = fitting_2_price + fitting_1_price
        $('.custom_length, .custom_length_mob').addClass('input-error')
      }
      else if(length.val() == ""){
        $('#hose_price').text("$0");
        sub_tottal = fitting_2_price + fitting_1_price;
      }
      else if($('input[name="custom_hose[variant_id]"]:checked').length == 1) {
        var price =  length_price * parseInt(length.val());
        $('#hose_price').text('$'+price.toFixed(2));
        sub_tottal = fitting_2_price + fitting_1_price + price;
      }
      else {
        sub_tottal = fitting_2_price + fitting_1_price
      }
      subtotal = parseFloat(sub_tottal) + assembly_fee;
      $('#subtotal-price').text('$'+ parseFloat(subtotal).toFixed(2));
    }

    function SyncFittingImages(fitting1, fitting2) {
      RemoveFittingError(fitting2);
      var label = $('input[name="custom_hose[variant_id]"]:checked').parent().first().text().trim();
      var name = $('input[name="fitting_'+fitting2+'_material"]:checked').val();

      var color = '';
      if (label == 'ZillaGreen®') {
        color = 'green';
      }
      else if(label == 'Brown Mulch') {
        color = 'brown';
      }

      UpdateVariantId(1);
      UpdateVariantId(2);

      if(name.split(' ').slice(-1) != 'Aluminum') {
        $('#hose_bg_img').addClass('Aluminum');
        $('#hose_bg_img').removeClass('Brass');
        $(`.${color}_header`).attr("src", $('.bg_'+color+'_brass_img').attr('src'));
      }
      else {
        $('#hose_bg_img').removeClass('Aluminum');
        $('#hose_bg_img').addClass('Brass');
        $(`.${color}_header`).attr("src", $('.bg_'+color+'_al_img').attr('src'));
      }
    }

    function RemoveFittingError(fitting) {
      $('input[name="fitting_'+fitting+'_material"]').next().removeClass('error-border')
      $('input[name="fitting_'+fitting+'_material"]').next().removeClass("selected_box");
      $('input[name="fitting_'+fitting+'_material"]:checked').next().addClass("selected_box");
      $('.block'+fitting+' .error-message-fitting').css('display', 'none');
      EnableAddtoCart();
    }

    function ChangeImage(fitting, radio_button) {
      var type = $('input[name="fitting_'+fitting+'_flexRadioDefault'+radio_button+'"]:checked').val();
      if ($(document).width() <= 767) {
        var label = $('input[name="custom_hose1[variant_id]"]:checked').parent().first().text().trim();
      }
      else {
        var label = $('input[name="custom_hose[variant_id]"]:checked').parent().first().text().trim();
      }

      var color = '';
      if (label == 'ZillaGreen®') {
        color = 'green';
      }
      else if(label == 'Brown Mulch') {
        color = 'brown';
      }

      if (type == null || type == 'Female') {
        $(`#fitting_${fitting}_Brass`).next().find('img').first().attr("src", images[`${color}_female_brass_img`]);
        $(`#fitting_${fitting}_Aluminum`).next().find('img').first().attr("src", images[`${color}_female_al_img`]);
      }
      else if (type == null || type == 'Male') {
        $(`#fitting_${fitting}_Brass`).next().find('img').first().attr("src", images[`${color}_male_brass_img`]);
        $(`#fitting_${fitting}_Aluminum`).next().find('img').first().attr("src", images[`${color}_male_al_img`]);
      }
    }

    function EnableAddtoCart() {
      if ($('input[name="fitting_2_flexRadioDefault2"]').is(':checked') && $('input[name="fitting_1_flexRadioDefault"]').is(':checked') &&
      $('input[name="fitting_2_material"]').is(':checked') && $('input[name="fitting_1_material"]').is(':checked') && $('input[name="custom_hose[variant_id]"]').is(':checked')
      && ($('.custom_length').val() != "" || $('.custom_length_mob').val() != "")) {
        $('#add_custom').prop('disabled', false).removeClass('disable-btn').addClass('add-to-cart');
        $('.cart-error-message').css('display', 'none');
      }
    }

    function RemoveFittingTypeError(radio_button, block) {
      $('.radio-group'+radio_button).removeClass('radio-group-error')
      $('.block'+block+' .error-message-fitting').css('display', 'none');

      EnableAddtoCart();
    }

    function AddBlockError(block_number) {
      $('.block'+block_number+' .error-message-fitting').css('display', 'block');
      DisableAddtoCart();
    }

    function DisableAddtoCart() {
      $('.add-to-cart').prop('disabled', true).addClass('disable-btn').removeClass('add-to-cart');
      $('.cart-error-message').css('display', 'block');
    }

    function SectionError(display) {
      $('.section-3 .error-message').css('display', display);
      $('.section-6 .error-message').css('display', display);
    }

    function UpdateVariantId(fitting_number) {
      mtext = $('.fitting_'+fitting_number+'_material:checked').val();
      ttext = $('.fitting_'+fitting_number+'_type:checked').val();
      var el = $('.variant-data').filter(function(){ return $(this).data().text.includes(mtext) && $(this).data().text.includes(ttext)})
      if( el.length == 1 && el.next('.variant-stock').data().text == true) {
        $('#fitting_'+fitting_number+'_variant').val(el.data('id'));
        $('#fitting_'+fitting_number+'_price').text('$'+el.data('text').split(',').slice(-1));
        UpdateSubTotal();
      }
    }

    function CheckOutOfStock(fitting, radio_button){
      var type1 = $('input[name="fitting_'+fitting+'_flexRadioDefault'+radio_button+'"]:checked').val();
      var material1 = $('.fitting_'+fitting+'_material')[0].value;
      var material2 = $('.fitting_'+fitting+'_material')[1].value;
      var el_material1_type1 = $('.variant-data').filter(function(){ return $(this).data().text.includes(material1) && $(this).data().text.includes(type1)})
      var el_material2_type1 = $('.variant-data').filter(function(){ return $(this).data().text.includes(material2) && $(this).data().text.includes(type1)})
      OutOfStock(el_material1_type1, 0, fitting, radio_button);
      OutOfStock(el_material2_type1, 1, fitting, radio_button);
    }

    function OutOfStock(element, index, fitting, radio_button){
      var material_name = $('.fitting_'+fitting+'_material')[index].nextElementSibling;
      if( element.next('.variant-stock').data().text == false) {
        material_name.lastElementChild.className = ('image-container disable-image');
        material_name.firstElementChild.style.color = '#A8A8A8';
        material_name.className = ('product-card disable-state');
        $('input[name="fitting_'+fitting+'_material"]')[index].checked = false;
        $('#fitting_'+fitting+'_price').text("$0");
        UpdateSubTotal();
      }
      else {
        material_name.lastElementChild.className = ('image-container');
        material_name.firstElementChild.style.color = 'black';
        if (material_name.className === 'product-card selected_box') {
          material_name.className = ('product-card selected_box');
          $('input[name="fitting_'+fitting+'_material"]')[index].checked =  true;
          $('#fitting_'+fitting+'_price').text('$'+element.data('text').split(',').slice(-1));
          UpdateSubTotal();
        }
        else {
          material_name.className = ('product-card');
          UpdateSubTotal();
        }
      }
    }
  }

  $('#cartSlider').on('hidden.bs.modal', function (e) {
    if (!(e.target.className.includes('custom_hose_verfication'))){
      $('#cartSlider.modal.right.fade, .modal.custom_hose_verfication').modal('hide');
    }
  });

  $(document).on('click', '.custom-page-btn', function () {
    $('.custom_hose_verfication').modal('hide');
  })
});

# touched on 2025-05-22T23:22:55.803114Z
# touched on 2025-06-13T21:17:43.958957Z