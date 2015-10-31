//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap3-typeahead.min
//= require bootstrap3-autocomplete-input.min
//= require index

$(document).ready(function() {
  header_scroll();
  infinity_scroll_main_page("#main-pagination");
  clickable_link();
  topics_filter();
  category_change();
  facets();
  search_form();
  post_reply();
  changeAjaxTab();
});
