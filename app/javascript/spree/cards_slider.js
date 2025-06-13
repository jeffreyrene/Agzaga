$(document).on('turbolinks:load', function(){
  if(!$('.products.show').length) {
    const tabSize = $('.card-pages-group').data('tab-size');
    const cardsGroup = $('.card-pages-group .cards');
    makeTabs();

    $(document).on('click', '.load-btn', function(){
      if ($(this).hasClass('disabled')) return false;
      let direction = $(this).hasClass('nav-forward') ? 1 : -1;
      switchTab(direction, $("#"+$(this).data('current-section')));
    });

    function addplaceholders(n, current_section){
      for (let i = 0; i < n; i++) {
        $(current_section).append(cardPlacholder());
      }

      if($('.pages.usa').length) {
        $(current_section).append($(current_section).next());
        $(current_section).find('.nav-next-button').addClass('show');
      }
    }

    function cardPlacholder() {
      return `<div class="slider-card" data-tab="" data-loaded="false">
        <div class="product-card-placeholder">
          <div class="image"></div>
          <div class="price"></div>
          <div class="name"></div>
        </div>
      </div>`;
    }

    function makeTabs(){
      cardsGroup.each(function() {
        const totalCards = parseInt(this.dataset['totalCards']);
        addplaceholders( totalCards - tabSize, this);

        $(this).children().each(function(i) {
          this.dataset['tab'] = parseInt(i/tabSize) + 1
        });
      });
    }

    const activeTab = (current_section) => parseInt($(current_section).find($('.slider-card.visible')).data('tab'));

    const switchTab = (n, current_section) => {
      let current = activeTab(current_section);
      let nextTab = current + n;
      $(current_section).find($(`.slider-card[data-tab="${current}"]`)).removeClass('visible');
      $(current_section).find($(`.slider-card[data-tab="${nextTab}"]`)).addClass('visible');
      enableDisableNavButtons(current_section);
      n > 0 && !($(current_section).find($(`.slider-card[data-tab="${nextTab}"]`)).data('loaded')) && loadProducts(nextTab, current_section)
    }

    const enableDisableNavButtons = (current_section) => {
      setBackButton(current_section);
      setForwadButton(current_section);
    }

    const setBackButton = (current_section) => {
      let button = $(current_section).prev().find($('.nav-back'));
      activeTab(current_section) > 1 ? button.removeClass('disabled') : button.addClass('disabled');
    }

    const setForwadButton = (current_section) => {
      let button = $(current_section).next().find($('.nav-forward'));
      activeTab(current_section) * tabSize < $(current_section).data('totalCards') ? button.removeClass('disabled') : button.addClass('disabled');

      if($('.pages.usa').length) {
        let button = $(current_section).find($('.nav-forward'));
        activeTab(current_section) * tabSize < $(current_section).data('totalCards') ? button.show() : button.hide();
      }
    }

    function loadProducts(tab, current_section) {
      let limit = tabSize
      let offset = (tab - 1) * tabSize
      let id = 'load-tab-' + tab
      const link =`<a id="${id}" href="/${$(current_section).attr('id')}_cards?limit=${limit}&offset=${offset}&tab=${tab}" data-remote="true">link</a>`
      $(current_section).append(link)
      $(`#${id}`)[0].click();
      $(`#${id}`).remove();
    }
  }
});

# touched on 2025-05-22T20:38:57.609417Z
# touched on 2025-05-22T20:44:34.094454Z
# touched on 2025-05-22T23:06:43.067728Z
# touched on 2025-05-22T23:25:20.450701Z
