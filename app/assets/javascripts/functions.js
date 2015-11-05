function infinity_scroll_main_page(selector) {
  if ($(selector + ' .pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('.pagination').html('<img src="/assets/loading.gif" alt="Loading..." title="Loading..." />');
        return $.getScript(url);
      }
    });
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
    reader.onload = function (e) { $(div_id).attr('src', e.target.result); }
    reader.readAsDataURL(input.files[0]);
  }
}

function topics_filter() {
  $(document).on("click", ".topics_filters", function() {
    show_loading();
  });
}

function show_loading() {
  $("#topics_list").html('<p class="text-center"><img src="/assets/loading.gif" alt="Loading..." title="Loading..." /></p>');
}

function category_change() {
  $(document).on('change', '#category-select', function() {
    show_loading();
    var value = $('#category-select').val();
    $.ajax({
      url: 'category_filter',
      type: 'GET',
      data: { category: value },
      error: function(request, status, error) {
        alert(error);
      }
    });
  });
}

function facets() {
  $(".search_form_filter").change(function(){
    $("#search_form_filter").submit();
  });
}

function search_form() {
  $(document).on('click', '#search_link', function() {
    $("#search_link").hide();
    $("#search_form").show();
  });
}

function message_reply() {
  $(document).on('click', '#add-reply', function() {
    if ($('#new-reply').is(':hidden')) {
      $('#new-reply').slideDown();
    }
    else {
      $("#new-reply").slideUp();
    }
  });
}

function new_topic() {
  $(document).on('click', "#start_new_topic", function() {
    if ($("new-topic").is(':hidden')) {
      $("#new-topic").slideDown();
    }
    else {
      $("#new-topic").slideUp();
    }
  });
}

function post_reply() {
  $(document).on('click', '#add-post-reply', function() {
    if ($('#new-post-reply').is(':hidden')) {
      $('#new-post-reply').slideDown();
    }
    else {
      $('#new-post-reply').slideUp();
    }
  });
}

function close_form() {
  $(document).on('click', '.close-button', function() {
    if ($("#new-post-reply").is(':visible')) {
      $("#new-post-reply").slideUp();
    }
    if ($("#edit-post").is(':visible')) {
      $("#edit-post").slideUp();
    }
    if ($("#new-topic").is(':visible')) {
      $("#new-topic").slideUp();
    }
  });
}

function checkActiveTab() {
  if ($('#myTabs').length > 0) {
    var type;
    $('.ajax-header-tab').each(function(i) {
      if ($(this).hasClass('active'))
        type = $(this).attr('data-tab');
    });
    ajaxTab(type);
  }
}

function resetPagination() {
  var ids = ["user-topics-pagination", "user-posts-pagination", "user-all-pagination"];
  for(i = 0; i < ids.length; i++)
    $('#' + ids[i]).html("");
}

function changeAjaxTab() {
  $(document).on('click', '.ajax-tab', function() {
    var type = $(this).attr('data-tab');
    ajaxTab(type);
  });
  checkActiveTab();
}

function notificationsBar() {
  setInterval(function() {
    getNotificationsData();
    }, 20000
  );
}

function getNotificationsData() {
  if ($('#notifications').length > 0) {
    $.ajax({
      method: "GET",
      url: "/notifications/new_notifications",
      dataType: "JSON",
      success: function(data, text, xhr) {
        if (data == 0) {
          $('#notifications').html("Notifications <span class='badge'>" + data + "</span>");
        } else {
          $('#notifications').html("Notifications <span class='badge badge-success'>" + data + "</span>");
        }
      }
    });
  }
}

function showLoadingData(clicked, id) {
  $(document).on('click', clicked, function() {
    $("#" + id).html('<p class="text-center"><img src="/assets/loading.gif" alt="Loading..." title="Loading..." /></p>');
  });
}

function resetNotifications() {
  $(document).on('click', '#notifications', function() {
    $('#notifications-list').empty();
  });
}
