$(document).ready(function() {
  if( $('.pages.net_wraps').length ) {
    enable_select2_in_quick_view();
    window.enable_select2_in_quick_view = enable_select2_in_quick_view;

    function enable_select2_in_quick_view() {
      $('.options-select').select2({
        minimumResultsForSearch: Infinity,
        width: '100%',
        closeOnSelect: true,
        allowClear: true
      });

      if ( $('#disable-select2').val() == "true" ){
        $(".product-options-select").prop("disabled", true);
      }
      else {
        $(".product-options-select").prop("disabled", false);
      }

      if ( $('#disable-quick-view-select2').val() == "true" ){
        $(".quick-view-options").prop("disabled", true);
      }
      else {
        $(".quick-view-options").prop("disabled", false);
      }
    }

    function searchText( current_selection_id ) {
      var target = $('#'+current_selection_id).parents('form').find('.options-select');

      var text = target.map( function() {
                    return $(this).data( 'option' )+ ': ' + $(this).val();
                  }).toArray().join(', ');

      if( target.length > 2 ) {
        text = text.replace(/,(?=[^,]*$)/, ', and');
      }

      return text;
    }

    function filterdData( data, current_selection_id ) {
      var target = $('#'+current_selection_id).parents('form').find('.options-select');

      target.each(function() {

        if( $(this).val() != "" && $(this).attr('id') === current_selection_id ) {

          var selection_text = $(this).data('option') + ': ' + $(this).val();

          data = data.filter(v => v.text.includes(selection_text));
        }
      });

      return data;
    }

    function getvariantData(product_id) {

      var data = $('.variants-data-for-' + product_id).map(function(){
                    return $(this).data();
                  }).toArray();

      return data;
    }

    var doNotRun = 0;

    $(document).on('change', "input:radio.variantid", function() {
      var children = $(this).closest('#inside-product-cart-form').children();

      if ( $("input:radio.variantid:checked").next().find('.out-of-stock').length == 1 ) {
        SetErrorOutofStock(children);
      }
      else {
        var stock_coount = $(this).next().find(".stock-count").html();
        if ($(this).next().find(".variant-backorderable").html() == 'true' && stock_coount <= 0) {
          children.find('.quantity')[0].removeAttribute("max")
        }
        else {
          children.find('.quantity').attr("max", parseInt(stock_coount = stock_coount));
        }
        children.find('.quantity').val(1);

        let pallets = [];
        let buy_in_bulk = $('.' + $(this).data('buy-in-bulk'));
        let pallet_section = $(document.createElement("div")).addClass("pallet-section");
        let pallet_id = "#" + $(this).data('targetPallet');
        $(pallet_id).children().each(function() {
          let pallet_name = $(this).data("volumePriceName");
          let pallet_quantity = $(this).data("volumePricesQuantity");
          let pallet_unit_price = $(this).data("volumeUnitPrice");
          let product_id = $(this).data("productId");
          pallets.push(create_pallets_for_product(pallet_name, pallet_quantity, pallet_unit_price, product_id));
        });

        let buy_in_bulk_text;
        if (pallets.length > 0) {
          var text = $('.pages.net_wraps').length ? 'Bulk Pricing' : 'Buy it in Bulk'
          buy_in_bulk_text = $(document.createElement("div")).addClass("buy-in-bulk-text").text(text);
          pallet_section.show();
        } else {
          buy_in_bulk_text = '';
          pallet_section.hide();
        }

        pallet_section.html(pallets);
        buy_in_bulk.html([buy_in_bulk_text, pallet_section]);
        RemoveErrorOutofStock(children);
      }
    });

    function create_pallets_for_product(name, quantity, unit_price, product_id) {
      var pallet_element =  ('<div class="pallets">'+
                                '<div class="add-pallet-to-cart-button" data-pallet-quantity="'+quantity+'" data-quantity-field="product-quantity-field-'+product_id+'">'
                                  +name+
                                '</div>'+
                                 '<div class="price-per-unit">'
                                  +`$${unit_price} Each`+
                                '</div>'+
                              '<div>');
      return pallet_element;
    }

    $(document).on('change', "input:radio.quick-view-variantid", function() {
      var closest_div = $(this).closest('.product-quick-view');

      if ( $("input:radio.quick-view-variantid:checked").next().find('.out-of-stock').length == 1 ) {
        SetErrorOutofStock(closest_div);
      }
      else {
        var stock_count = $(this).next().find(".stock-count").html();
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

      var searchQuery = searchText(current_selection_id);

      var variantData = getvariantData(current_selection_id.split('-')[0]);

      var elem = variantData.filter( x => x.text === searchQuery )[0];

      if(elem !== undefined) {
        $('#variant_id_'+elem.id).trigger('click');
      } else {
        $('input[type="radio"]:checked').attr('checked', false);

        var data = filterdData( variantData, current_selection_id );

        var target = $('#'+current_selection_id).parents('form').find('.options-select');

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

    $(document).on('change', '.product-quick-view  input[type="radio"]', function(){
      var variantPrice = $(this).data("price");

      if (variantPrice) {
        $(this).parents('.product-quick-view').find(".current-price").text(variantPrice);
      }
    });
  }

  if ($('.show-subscriber').length && $('#cta-registration-modal').length) {
    setTimeout(function(){
      $('#cta-registration-modal').modal('toggle');
    }, 3000);
  }

  if ($('.early-bird-show-subscriber').length && $('#early-bird-registration-modal').length) {
    setTimeout(function(){
      $('#early-bird-registration-modal').modal('toggle');
    }, 2000);
  }
});

# touched on 2025-05-22T23:07:00.709674Z

# touched on 2025-06-13T21:16:56.186755Z