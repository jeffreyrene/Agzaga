$(document).on('turbolinks:load', function() {
  if( $('.pages.chuckwagon_dvd').length) {

    enable_select2_in_quick_view();
    window.enable_select2_in_quick_view = enable_select2_in_quick_view;

    function enable_select2_in_quick_view() {
      $('.options-select').select2({
        minimumResultsForSearch: Infinity,
        width: '100%',
        closeOnSelect: true,
        allowClear: true
      });
    }

    function searchText( ele ) {
      var target = $(ele).parents('form').find('.options-select');

      var text = target.map( function() {
                    return $(this).data( 'option' )+ ': ' + $(this).val();
                  }).toArray().join(', ');

      if( target.length > 2 ) {
        text = text.replace(/,(?=[^,]*$)/, ', and');
      }

      return text;
    }

    function filterdData( data, ele, current_selection_id ) {
      var target = $(ele).parents('form').find('.options-select');

      target.each(function() {

        if( $(this).val() != "" && $(this).attr('id') === current_selection_id ) {

          var selection_text = $(this).data('option') + ': ' + $(this).val();

          data = data.filter(v => v.text.includes(selection_text));
        }
      });

      return data;
    }

    function getvariantData(product_id, ele) {

      var data = $(ele).parents('form').find('.variants-data-for-' + product_id).map(function(){
                    return $(this).data();
                  }).toArray();

      return data;
    }

    var doNotRun = 0;

    $(document).on('change', 'input[type="radio"]', function() {
      var selected_img_id = $(this).attr('id').split('_')[2];
      var product_id = $(this).data('productId');
      var product_section = $(this).data('productSection');
      var selected_variant_url = $('.' + product_section + '-product-images-' + product_id).find('span.pro-img.img-' + selected_img_id).data('src');
      $('#'+ product_section +'-product-image-' + product_id).attr('src', selected_variant_url);

      let closest_div = $(this);

      if ($(this).parents('.content').length != 0)
        {
          closest_div = $(this).parents('.content');
        }
        else
        {
          closest_div = $(this).parents('.chuckwagon-product-block');
        }
      if ( closest_div.find("input[type='radio']:checked").next().find('.out-of-stock').length == 1 ) {
        SetErrorOutofStock(closest_div);
      }
      else {

        let stock_count = $(this).next().find(".stock-count").html();
        if ($(this).next().find(".variant-backorderable").html() == 'true' && stock_count <= 0) {
          closest_div.find('.quantity')[0].removeAttribute("max")
        }
        else {
          closest_div.find('.quantity').attr("max", parseInt(stock_count = stock_count));
        }
        closest_div.find('.quantity').val(1);
        RemoveErrorOutofStock(closest_div);
      }
    });

    function SetErrorOutofStock(parent_div) {
      parent_div.find('#add-to-cart-button').addClass('out-of-stock-btn').removeClass('btn-gradient-orange').prop("disabled", true);
      parent_div.find('.quantity-btn-group').addClass('disable-quantity-btn-group');
      parent_div.find('.stock-error-message').css('display', 'none').html('');
    }

    function RemoveErrorOutofStock(parent_div) {
      parent_div.find('.quantity-btn-group').removeClass('disable-quantity-btn-group');
      parent_div.find('#add-to-cart-button').removeClass('out-of-stock-btn').addClass('btn-gradient-orange').prop("disabled", false);
      parent_div.find('.add-btn').removeClass( 'disable_btn' ).attr( "disabled", false);
      parent_div.find('.sub-btn').removeClass( 'disable_btn' ).attr( "disabled", false);
      parent_div.find('.stock-error-message').css('display', 'none').html('');
    }

    $(document).on('change', '.options-select', function() {
      if( doNotRun > 0 ) {
        return true;
      }
      doNotRun++;

      var current_selection_id = $(this).attr('id');

      var searchQuery = searchText(this);

      var variantData = getvariantData(current_selection_id.split('-')[0], this);

      var elem = variantData.filter( x => x.text === searchQuery )[0];


      if(elem !== undefined) {
        $(this).parents('form').find('#variant_id_'+elem.id).trigger('click');
      } else {
        $(this).parents('form').find('input[type="radio"]:checked').attr('checked', false);

        var data = filterdData( variantData, this, current_selection_id );

        var target = $(this).parents('form').find('.options-select');

        target.each(function() {

          var current_value = $(this).val();

          if( $(this).attr('id') !== current_selection_id ) {

            optionText = $(this).data('option')+ ': ';

            var changedOptions = 0;

            $(this).children().each(function() {
              $(this).prop('disabled', false);

              if( data.filter( (x) => x.text.includes( optionText + $(this).val())).length < 1 ) {
                $(this).prop('disabled', true);
                changedOptions++;
              }
            });

            if( changedOptions > 0 && $(this).find( 'option[value="'+current_value+'"]:disabled' ).length > 0 ) {
              $(this).val(null).trigger('change');
            }
          }
        });
      }
      doNotRun = 0;
    });

    $(document).on('change', 'input[type="radio"]', function() {
      var variantPrice = parseFloat($(this).data('price').replace('$',''));

      if (variantPrice) {
        if ($(this).parents('.content').length != 0)
        {
          $(this).parents('.content').find(".money-whole").first().text(Math.floor(variantPrice));
          $(this).parents('.content').find(".money-decimal").first().text((variantPrice%1).toFixed(2).substring(2));
        }
        else
        {
          $(this).parents('.pre-order-inner-section').find(".money-whole").text(Math.floor(variantPrice));
          $(this).parents('.pre-order-inner-section').find(".money-decimal").text((variantPrice%1).toFixed(2).substring(2));
        }
      }
    });

    $('input[type="radio"]:checked').trigger('change');
  }
});

# touched on 2025-05-22T19:22:15.139638Z
# touched on 2025-05-22T20:44:38.675613Z
# touched on 2025-05-22T22:38:59.651104Z
# touched on 2025-05-22T23:43:48.643702Z

# touched on 2025-06-13T21:14:57.305581Z
# touched on 2025-06-13T21:18:32.100218Z