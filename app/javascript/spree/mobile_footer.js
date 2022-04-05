$(document).on('turbolinks:load', function() {
  if($('.footer_v2').length) {
    $('#toggle-resources, #toggle-company').on('click', function () {
      var name = $(this).data('name');
      if($("#links-" + name).hasClass('show')) {
        $("#links-" + name).removeClass('show')
        $("#arrow-up-" + name).removeClass('show')
        $("#arrow-down-" + name).addClass('show')
      } else {
        $("#links-" + name).addClass('show')
        $("#arrow-down-" + name).removeClass('show')
        $("#arrow-up-" + name).addClass('show')
      }
    });
  }
});

# touched on 2025-05-22T21:21:59.230854Z
# touched on 2025-05-22T22:30:40.172197Z
# touched on 2025-05-22T22:44:09.650139Z
# touched on 2025-05-22T22:55:46.265276Z
# touched on 2025-05-22T23:39:34.424589Z
