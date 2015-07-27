$(document).ready(function() {
  infinity_scroll();
  clickable_link();
});


var infinity_scroll = function() {
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url;
      url = $('.pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('.pagination').html('<img src="/assets/loading.gif" alt="Loading..." title="Loading..." />');
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
}

var clickable_link = function() {
  $('.td_link').on("click", function() {
    document.location = $(this).attr('data-link');
  });
}
