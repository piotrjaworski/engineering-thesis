//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require index

$(document).ready(function() {
  header_scroll();
  infinity_scroll_main_page("#main-pagination");
  infinity_scroll_main_page("#user-all-pagination");
  infinity_scroll_main_page("#user-posts-pagination");
  infinity_scroll_main_page("#user-topics-pagination");
  clickable_link();
  topics_filter();
  category_change();
  facets();
  search_form();
});
