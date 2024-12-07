import { createPopper } from '@popperjs/core';

$(document).on('turbolinks:load', function() {
  $(document).on('click','[data-toggle="ag-tooltip"]', {} ,function(e){
    var commonAttr = $(this).data('target');
    var tooltip;

    if(document.querySelector(`[data-related='${commonAttr}']`)) {
      tooltip = document.querySelector(`[data-related='${commonAttr}']`);
      showToolip($(this), tooltip);
    } else {
      createTooltip($(this));
      tooltip = document.querySelector(`[data-related='${commonAttr}']`);
      showToolip($(this), tooltip);

    }
  });

  $(document).on('mouseleave','[data-toggle="ag-tooltip"]', {} ,function(e){

    var commonAttr = $(this).data('target');
    var tooltip = document.querySelector(`[data-related='${commonAttr}']`);

    if(!$(this).data('dismiss') && !$(this).data('link')) {
      hideToolip(tooltip);
    } else if (!$(this).data('dismiss') && $(this).data('link')) {
      $(document).on('click', function() {
        hideToolip(tooltip);
      })
    } else {
      $(".ag-tooltip-close-icon").on('click', function(){
        hideToolip(tooltip);
      })
    }
  });

  function createTooltip ($this) {
    var tooltipDiv = $(document.createElement('div')).addClass('ag-tooltip').attr('data-related', $this.data('target'));

    createTooltipHeader($this, tooltipDiv);
    createTooltipContent($this, tooltipDiv);
    createTooltipLink($this, tooltipDiv);
    createTooltipArrow($this, tooltipDiv);
    createCloseIcon($this, tooltipDiv);

    $('body').append(tooltipDiv);
  }

  function createTooltipHeader ($this, tooltipDiv) {
    if ($this.data('header')) {
      var tooltipHeader = $(document.createElement('div')).addClass('ag-tooltip-header').html($this.data('header'))
      tooltipDiv.append(tooltipHeader);
    }
  }

  function createTooltipContent ($this, tooltipDiv) {
    if ($this.data('content')) {
      var tooltipContent = $(document.createElement('div')).addClass('ag-tooltip-content').html($this.data('content'))
      tooltipDiv.append(tooltipContent);
    }
  }

  function createTooltipLink ($this, tooltipDiv) {
    if ($this.data('link') && $this.data('link-target')) {
      var tooltipLink = $(document.createElement('a')).addClass('ag-btn-xs ag-tooltip-button').html($this.data('link')).attr("href", $this.data('link-target'));
      tooltipDiv.append(tooltipLink);
    }
  }

  function createTooltipArrow ($this, tooltipDiv) {
    if ($this.data('placement')) {
      var tooltipArrow = $(document.createElement('div')).attr('id', 'arrow').attr('data-popper-arrow', '');
      tooltipDiv.append(tooltipArrow);
    }
  }

  function createCloseIcon ($this, tooltipDiv) {
    if ($this.data('dismiss')) {
      var tooltipCloseIcon = $(document.createElement('div')).addClass("ag-tooltip-close-icon");
      tooltipDiv.append(tooltipCloseIcon);
    }
  }

  function showToolip ($this, tooltip) {
    var popperInstance = setPopperInstance($this, tooltip);

    tooltip.setAttribute('data-show', '');

    popperInstance.setOptions((options) => ({
      ...options,
      modifiers: [
        ...options.modifiers,
        { name: 'eventListeners', enabled: true },
      ],
    }));

    popperInstance.update();
  }

  function setPopperInstance ($this, tooltip) {
    var popperInstance;

    if ($this.data('placement')) {
      popperInstance = createPopper($this[0], tooltip, {
        placement: $this.data('placement'),
        modifiers: [
          {
            name: 'offset',
            options: {
              offset: [0, 8],
            },
          },
        ],
      });
    } else {
      popperInstance = createPopper($this[0], tooltip, {
        modifiers: [
          {
            name: 'offset',
            options: {
              offset: [0, 5],
            },
          },
        ],
      });
    }

    return popperInstance;
  }

  function hideToolip (tooltip) {
    tooltip.removeAttribute('data-show');
  }
})

# touched on 2025-05-22T20:38:43.746157Z
# touched on 2025-05-22T21:57:37.889612Z

# touched on 2025-06-13T21:20:05.492050Z