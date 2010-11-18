(function($) {
  $(function() {
    $('ul.tabulator_header').each(function() {
      $(this).find('li').each(function(i) {
        $(this).click(function(){
          $(this).addClass('current').siblings().removeClass('tabulator_current')
            .parents('div.tabulator').find('div.tabulator_inner_block').hide().end().find('div.tabulator_inner_block:eq('+i+')').show();
        });
      });
    });
  })
})(jQuery)