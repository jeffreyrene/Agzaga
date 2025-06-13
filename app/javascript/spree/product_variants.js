$(document).ready(function() {
  if( $('.products.show').length || $('.products.index, .pages.net_wraps, .pages.usa').length || $('.orders.edit').length || $('.orders.show').length || $('.home.index').length || $('.product_categories.index').length || $('.favorites.index').length || $('.taxons.show').length || $('.products.deals').length ) {
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
      var target = $('.options-section');
      var text = target.map( function() {

                    return $(this).data( 'option' )+ ': ' + $(this).find(':checked').val();
                  }).toArray().join(', ');

      if( target.length > 2 ) {
        text = text.replace(/,(?=[^,]*$)/, ', and');
      }

      return text;
    }

    function filterdData( data, current_selection_id ) {
      var target = $('.options-section');
      target.each(function() {

        if( $(this).find(':checked').val() != "" && $(this).attr('id') === current_selection_id ) {

          var selection_text = $(this).data('option') + ': ' + $(this).find(':checked').val();

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
        if ($(this).next().find(".variant-backorderable").html() == 'true') {
          children.find('.quantity').attr("max", 500);
        }
        else {
          children.find('.quantity').attr("max", parseInt(stock_coount = stock_coount));
        }
        children.find('.quantity').val(1);

        let pallets = [];
        let buy_in_bulk = $('.buy-in-bulk');
        let pallet_section = $(document.createElement("div")).addClass("pallet-section");
        let pallet_id = "#" + $(this).data('targetPallet');
        $(pallet_id).children().each(function() {
          let pallet_name = $(this).data("volumePriceName");
          let pallet_quantity = $(this).data("volumePricesQuantity");
          let pallet_unit_price = $(this).data("volumeUnitPrice");
          pallets.push(create_pallets_for_product(pallet_name, pallet_quantity, pallet_unit_price));
        });

        let buy_in_bulk_text;
        if (pallets.length > 0) {
          buy_in_bulk_text = $(document.createElement("div")).addClass("buy-in-bulk-text").text('Bulk Pricing Options');
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

    function create_pallets_for_product(name, quantity, unit_price) {
      var pallet_element =  ('<div class="pallets">'+
                                '<div class="add-pallet-to-cart-button" data-pallet-quantity="'+quantity+'">'
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
      parent_div.find('#add-to-cart-button').addClass('out-of-stock-btn restock-text-change notify-icon').removeClass('btn-gradient-orange');
      parent_div.find('#add-to-cart-button').prop("type", "button");
      parent_div.find('#add-to-cart-button').attr('data-product-type', 'variant');
      parent_div.find('.quantity-btn-group').addClass('disable-quantity-btn-group');
      parent_div.find('.stock-error-message').css('display', 'none').html('');
    }

    function RemoveErrorOutofStock(parent_div) {
      parent_div.find('.quantity-btn-group').removeClass('disable-quantity-btn-group');
      parent_div.find('#add-to-cart-button').removeAttr('data-product-type');
      parent_div.find('#add-to-cart-button').prop("type", "submit");
      parent_div.find('#add-to-cart-button').removeClass('out-of-stock-btn restock-text-change notify-icon').addClass('btn-gradient-orange').prop("disabled", false);
      parent_div.find('.add-btn').removeClass( 'disable_btn' ).attr( "disabled", false);
      parent_div.find('.sub-btn').removeClass( 'disable_btn' ).attr( "disabled", false);
      parent_div.find('.stock-error-message').css('display', 'none').html('');
    }

    $(document).on('change', '.options-select, .color-options', function() {
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
        stock_count = $('#variant_id_'+elem.id).data('stock-count')
        if($('#variant_id_'+elem.id).data('is-backorderable') || stock_count >= 100) {
          $('.stock-detail').hide();
        } else {
          $('.stock-on-hand').text(stock_count)
          $('.stock-detail').show();
        }

        $('.product-variant-sku').text($('#variant_id_'+elem.id).data('variant-sku'));

        $(this).parents('.add-to-cart-section').find('.current-price').text($('#variant_id_'+elem.id).data('price'));
        if($('.variant_id_'+elem.id).length) {
          var target = $('.options-section');
          $('.show-out-of-stock-notification').removeClass('show-out-of-stock-notification');

          target.each(function() {
            $(this).find(':checked').addClass('show-out-of-stock-notification');
            $(this).find(':checked').next().find('.notify-icon').show();
          });
        } else {
          $('.show-out-of-stock-notification').removeClass('show-out-of-stock-notification');
          $('.notify-icon').hide();
        }

        if ($('#variant_id_'+elem.id).data('is-dropship')) {
          $('.shipping-estimate-time').html(`
            <svg width="20" height="20" viewBox="0 0 640 512" xmlns="http://www.w3.org/2000/svg">
              <path d="M48 0C21.5 0 0 21.5 0 48V368c0 26.5 21.5 48 48 48H64c0 53 43 96 96 96s96-43 96-96H384c0 53 43 96 96 96s96-43 96-96h32c17.7 0 32-14.3 32-32s-14.3-32-32-32V288 256 237.3c0-17-6.7-33.3-18.7-45.3L512 114.7c-12-12-28.3-18.7-45.3-18.7H416V48c0-26.5-21.5-48-48-48H48zM416 160h50.7L544 237.3V256H416V160zM112 416a48 48 0 1 1 96 0 48 48 0 1 1 -96 0zm368-48a48 48 0 1 1 0 96 48 48 0 1 1 0-96z"/>
            </svg>
            <span class="estimate-time">Ships direct from Mfg. in 3-5 business days</span>
          `);
        }else{
          $('.shipping-estimate-time').html(`
            <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M14.1007 12.8995C13.5075 13.4927 12.3487 14.6515 11.4138 15.5863C10.6328 16.3674 9.36738 16.3672 8.58633 15.5862C7.66878 14.6686 6.53036 13.5302 5.89966 12.8995C3.63501 10.6348 3.63501 6.96313 5.89966 4.69848C8.1643 2.43384 11.836 2.43384 14.1007 4.69848C16.3653 6.96313 16.3653 10.6348 14.1007 12.8995Z" stroke="#71717A" stroke-width="1.67" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M12.1748 8.79899C12.1748 10 11.2012 10.9736 10.0002 10.9736C8.79915 10.9736 7.82554 10 7.82554 8.79899C7.82554 7.59798 8.79915 6.62437 10.0002 6.62437C11.2012 6.62437 12.1748 7.59798 12.1748 8.79899Z" stroke="#71717A" stroke-width="1.67" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span class="estimate-time">Usually Arrives in 3-5 Days</span>
          `);
        }
      } else {
        $('input[type="radio"]:checked').attr('checked', false);

        var data = filterdData( variantData, current_selection_id );

        var target = $('.options-section');

        target.each(function() {
          var current_value = $(this).find(':checked').val();
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

    $(document).on('click', '.notify-icon', function() {
      var current_value = $('.notify-icon').data('productType') == 'master' ?  $('#variant_id').val() : $('.product-variants').find(':checked').val();
      $("#stock-update-form input[name='my_field']").val(current_value);
      $("#stock-update-btn").click();
    });

    $(document).on('change', '.product-quick-view  input[type="radio"]', function(){
      var variantPrice = $(this).data("price");

      if (variantPrice) {
        $(this).parents('.product-quick-view').find(".current-price").text(variantPrice);
      }
    });

    if($('.products.show').length) {
      $('.master-product-stock').length ? $('.stock-detail').show() : $('.stock-detail').hide();
      $('.color-options').trigger('change');
    }
  }
});

# touched on 2025-05-22T20:34:21.259294Z
# touched on 2025-05-22T21:58:06.033910Z
# touched on 2025-05-22T22:58:53.958315Z

# touched on 2025-06-13T21:14:17.639361Z
# touched on 2025-06-13T21:20:23.413294Z