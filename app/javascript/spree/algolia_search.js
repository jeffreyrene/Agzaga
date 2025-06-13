import algoliasearch from "algoliasearch";
import { autocomplete } from '@algolia/autocomplete-js';
import { createLocalStorageRecentSearchesPlugin } from '@algolia/autocomplete-plugin-recent-searches';

const recentSearchesPlugin = createLocalStorageRecentSearchesPlugin({
  key: 'navbar',
});

$(document).on('turbolinks:load', function() {
  window.disablePageScroll = disablePageScroll;
  window.enablePageScroll = enablePageScroll;

  if( $('.navbar_v2').length) {
    var algolia_keys = $('.algolia-keys').data();
    var client = algoliasearch(algolia_keys.algolia_id, algolia_keys.algolia_search_key);
    var index = client.initIndex(algolia_keys.algolia_index);
    var recent_searches_count = recentSearchesPlugin.data.getAll().length;
    var mobile_breakpoint = ($('.pages.freedom_wrap, .pages.net_wraps, .pages.usa').length) ? 991 : 767;

    $('.search-input').on('input', function() {
      var searchedText = searchFieldText();

      if(recent_searches_count > 0 || searchedText != '' && searchedText.length > 1) {
        markSearchListBoxActive(this)
        performSearch();
      } else if($(document).width() > mobile_breakpoint) {
        $('.search-list-box.active').hide();
        enablePageScroll();
      }
    });

    $(document).on('click', '.search-input', function() {
      $('.nav-header-container').hide();
      $('.no-result-found').hide();

      if ($(document).width() <= mobile_breakpoint && $(this).data('mobileView') === true) {
        markSearchListBoxActive(this)
        $('.search-list-box.active').show();
        $('#modal-search-bar').focus();
        $('#modal-search-bar').val($(this).val()).click();
        disablePageScroll();
      }

      if(recent_searches_count > 0) {
        $('.search-feature-block').hide();
        markSearchListBoxActive(this);
        !($(this).data('mobileView')) && performSearch();
      }
    });

    $(document).on('click', '.close-search', {}, function() {
      $('.search-input').val('');
      performSearch();
    });

    $(document).on('click', '.m-arrow', {}, function() {
      $('.search-input').val('');
      $('.search-input:visible').parents('form').submit();
    });

    $(document).on("click", function(event) {
      if((!$(event.target).parents('.search-form_v2').length) && ($('.search-list-box:visible').length)) {
        $('.search-list-box').hide();
        $('#landing-page-search').hide();
        $('.search-icon').show();
        enablePageScroll();
      }
    });

    $(document).on('click', '.search-list-item', {}, function() {
      var searchText = $(this).data("searchText");
      searchText = searchText || $(this).text();

      $('.search-input:visible').val(searchText).parents('form').submit();
    });

    $(document).on('click', '.query-popular', {}, function(e) {
      $('.search-input:visible').val($(this).prev().text());
    });

    $('.navbar_search').on('submit', function() {
      var searchedText = $(this).find('.search-input').val().trim();

      if(searchedText != '') {
        const item =  {
                        id: searchedText,
                        label: searchedText
                      };
        recentSearchesPlugin.data.addItem(item);
      }
    });

    $('.search-close-icon').on('click', function(){
      $('.search-list-box').hide();
      enablePageScroll();
    });

    $('.clear-history').on('click', function(){
      clearAllRecentSearches();
    });

    function performSearch() {
      var searchText = searchFieldText();
      $('.no-result-found').hide();
      $('.recent-searches, .nav-header-container').hide();

      var productLimit = 9;
      index.search( searchText, { hitsPerPage: productLimit, page: 0 })
      .then(function(content) {
        if (content.hits.length > 0) {
          showSearchedProducts(content);
          showRecentSearches();
          $('.search-list-box.active, .products-list, .search-list-block, .search-feature-block, .mobile-search-results').show();
          disablePageScroll();

          if(searchText != '') {
            $('.search-list-block').removeClass('full-width');
            if($(document).width() <= mobile_breakpoint) {
              $('.mobile-search-results').show();
            } else {
              $('.search-field-icon').removeClass('d-glass');
              $('.search-field-icon').addClass('close-search');
            }
          } else {
            (recent_searches_count > 0) && $('.recent-searches, .nav-header-container').show();
            $('.mobile-search-results').hide();
            $('.search-list-box, .search-feature-block, .products-list, .popular-searches, .popular-searches-heading').hide();
            enablePageScroll();
            $('.search-list-block').addClass('full-width');

            if($(document).width() > mobile_breakpoint) {
              $('.search-field-icon').addClass('d-glass');
              $('.search-field-icon').removeClass('close-search');
            }
          }

          $('.search-list-box.active').css('display', 'flex');
          disablePageScroll();

          if ($( document ).width() < 1025) {
            $('.search-feature-block').hide();
          }
        }
        else {
          $('.search-feature-block').hide();
          $('.products-list').hide();
          $('.search-list-block').hide();
          $('.no-result-heading').html('');
          searchText != '' && $('.no-result-found').show();
          $('.no-result-heading').append("'"+searchText+"'");
          $('.mobile-search-results').hide();
        }
      });
    }

    function searchFieldText() {
      var searchFieldSelector = ($(document).width() < 768)? '.search-input:visible#modal-search-bar' : '.search-input:visible';
      return $(searchFieldSelector).val().trim();
    }

    function productLink(slug) {
      return (window.location.origin + '/products/' + slug);
    }

    function searchProduct() {
      $('.search-list-box.active').hide();
      enablePageScroll();

      var dataForRecent = $(this).data('search').recentText;
      var slug = $(this).data('search').slugText;

      const item =  {
                      id: dataForRecent,
                      label: dataForRecent
                    };

      recentSearchesPlugin.data.addItem(item);
      window.location = productLink(slug);
    }

    function showSearchedProducts(content) {
      var products = [];
      var products_list = [];
      var searched_products_section = $(".search-list-box.active .search-feature-block .products-area");

      if ($( document ).width() > 991) {
        content.hits.forEach(function(item) {
          products.push(create_product_for_desktop_view(item));
          products_list.push(products_list_view(item))
        });
      } else {
        searched_products_section = $('.search-list-box.active .search-list-block .mobile-search-results');
        content.hits.forEach(function(item) {
          products.push(create_product_for_mobile_view(item));
        });
      }

      searched_products_section.html(products);
      $('.search-list-box.active .products-list').html(products_list);
    }

    function create_product_for_desktop_view(data) {
      var original_price = '';
      var tag = '';
      var on_sale = '';
      if(data.on_sale) {
        original_price = '<div class="original-price">List Price: '+
                          '<span>$'+data.original_price+'</span>'+
                         '</div>'
        tag = '<div class="discount-percentage">'+ data.discount_percentage +'% OFF</div>'
        on_sale = 'on-sale';
      }

      var product_label = data.active_label != null ? data.active_label.display_text : ''
      var label_color = data.active_label != null ? data.active_label.color : ''
      var label_text_color = data.active_label != null ? data.active_label.display_text_color : ''
      var product_card = $(document.createElement("div")).addClass('product-container');
      product_card.html(
        '<a href="'+productLink(data.slug)+'"class="search-card" data-turbolinks="false">'+
          '<div class="content-container">'+
            '<div class="image-section">'+
              '<img src="'+data.product_image+'" class="image-container"/>'+
            '</div>'+
            '<div class="product-details-container">'+
              '<div class="product-label" style="--label-color: '+label_color+'; --label_display_text_color: '+label_text_color+'">'+ product_label +'</div>'+
              '<div class="product-price '+ on_sale +'">$'+data.price+ tag +'</div>'+
              original_price+
              '<div class="product-name">'+data.name+'</div>'+
            '</div>'+
          '</div>'+
        '</a>'
      );

      return product_card[0]
    }

    function create_product_for_mobile_view(data) {
      var searchElementContainer = $(document.createElement("div")).addClass("search-element-container");
      var searchElement = $(document.createElement("div")).addClass("search-list-item-group");
      var searchTextForDisplay = boldActivelyMatchedCharacters(data.name);

      searchElement.append(
                            '<div class="search-result-item search-list-item" data-search-text="'+data.name+'">'+searchTextForDisplay+'</div>' +
                            '<div class="query-popular"></div>'
                          );

      searchElementContainer.append(searchElement);
      return searchElementContainer[0];
    }

    function products_list_view(data) {
      var resultsListElement = $(document.createElement("div")).addClass("search-list-item-group");
      data.name = boldActivelyMatchedCharacters(data.name);
      resultsListElement.append(
                                  '<div class="products-list-item search-list-item">'+data.name+'</div>'+
                                  '<div class="query-popular"></div>'
                                );
      return resultsListElement[0];
    }

    function recent_search_item(data) {
      var recentSearchElement = $(document.createElement("div")).addClass("search-list-item-group");
      data = boldActivelyMatchedCharacters(data);
      recentSearchElement.append(
                                  '<div class="recent-search-list-item search-list-item">'+data+'</div>'+
                                  '<div class="remove-recent"></div>'
                                );
      recentSearchElement.on('click', removeRecentSearch);
      return recentSearchElement[0];
    }

    function popular_search_item(data) {
      var popularSearchElement = $(document.createElement("div")).addClass("search-list-item-group");
      popularSearchElement.append(
                                  '<div class="popular-search-list-item search-list-item">'+data+'</div>'+
                                  '<div class="query-popular"></div>'
                                );
      return popularSearchElement[0];
    }

    function removeRecentSearch(event) {
      if($(event.target).hasClass('remove-recent')) {
        recentSearchesPlugin.data.removeItem($(this).find('.search-list-item').text());
        $(this).hide();

        if (recentSearchesPlugin.data.getAll().length == 0) {
          $('.search-list-box.active').hide();
          enablePageScroll();
        }
        setTimeout(function(){
          showRecentSearches();
          updateRecentSearchesCount();
        }, 200);
      }
    }

    function showRecentSearches() {
      $('.search-list-box.active .recent-searches, .search-list-box.active .popular-searches').html('');
      $('.search-list-box.active .nav-header-container, .search-list-box.active .popular-searches-heading').hide();

      var searchedText = searchFieldText();
      var recentSearches = recentSearchesPlugin.data.getAll();
      var recentsCount = recentSearches.length

      if( recentSearches != "") {
        recentSearches = recentSearches.filter(function(item){ return item.label.toLowerCase().trim().includes(searchedText.toLowerCase()) });
        recentsCount = recentSearches.length;
      }

      if( recentsCount > 0 && searchedText == '') {
        $('.search-list-box.active .nav-header-container').show();

        var recentSearchElements = []

        $(recentSearches).each(function(key, data){
          recentSearchElements.push(recent_search_item(data.label));
        });

        $('.search-list-box.active .recent-searches').html(recentSearchElements);
      } else {
        $('.search-list-box.active .nav-header-container').hide();
        enablePageScroll();
      }
    }

    function boldActivelyMatchedCharacters(record) {
      var searchInput = searchFieldText();
      var separateWord = searchInput.toLowerCase().split(' ');
      for (var i = 0; i < separateWord.length; i++) {
        separateWord[i] = separateWord[i].charAt(0).toUpperCase() +
        separateWord[i].substring(1);
      }

      for (var i = 0; i < separateWord.length; i++) {
        if (record.includes(separateWord[i])) {
          record = record.replace(separateWord[i], '<b>' + separateWord[i] + '</b>');
        }
      }
      return record;
    }

    function clearAllRecentSearches() {
      for (let iteration = 0; iteration < $('.remove-recent').length; iteration++) {
        var recent_search = $($('.remove-recent')[iteration]).parent();
        recentSearchesPlugin.data.removeItem(recent_search.find('.search-list-item').text());
        recent_search.hide();
      }
      $('.nav-header-container').hide();
      updateRecentSearchesCount();

      if ($(document).width() > mobile_breakpoint) {
        $('.search-list-box.active').hide();
        enablePageScroll();
      }
    }

    function markSearchListBoxActive($this){
      $('.search-list-box.active').removeClass("active");
      if($this.id === 'modal-search-bar') {
        $($this).parents('.search-list-box').addClass("active");
      } else {
        $($this).siblings('.search-list-box').addClass("active");
      }
    }

    function updateRecentSearchesCount() {
      recent_searches_count = recentSearchesPlugin.data.getAll().length;
    }
  }

  function disablePageScroll() {
    $('body').addClass('modal-open');
  }

  function enablePageScroll() {
    $('.modal-open:visible').length &&  $('body').removeClass('modal-open');
  }
});

# touched on 2025-05-22T23:43:54.081957Z
# touched on 2025-06-13T21:16:40.793254Z