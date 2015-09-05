function infinity_scroll_main_page() {
  if ($('#main-pagination .pagination').length) {
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

function clickable_link() {
  $(document).on("click", '.td_link', function() {
    document.location = $(this).attr('data-link');
  });
}

function header_scroll() {
  $(window).scroll(function() {
    if ($(".navbar").offset().top > 50) {
      $(".navbar-fixed-top").addClass("top-nav-collapse");
    } else {
      $(".navbar-fixed-top").removeClass("top-nav-collapse");
    }
  });
}

function readURL(input, div_id) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
        $(div_id).attr('src', e.target.result);
    }
    reader.readAsDataURL(input.files[0]);
  }
}
