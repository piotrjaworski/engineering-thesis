//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap3-typeahead.min
//= require bootstrap3-autocomplete-input.min
//= require functions

$(document).ready(function() {
  header_scroll();
  infinity_scroll_main_page("#main-pagination");
  clickable_link();
  topics_filter();
  category_change();
  facets();
  search_form();
  message_reply();
  post_reply();
  new_topic();
  close_form();
  changeAjaxTab();
  getNotificationsData();
  notificationsBar();
  showLoadingData('.messages-label', 'messages_table');
});
