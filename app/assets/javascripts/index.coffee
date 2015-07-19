jQuery ->
  $('#loading_gif').hide()
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next_page').attr('href')
      if url &&  $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').hide()
        $('#loading_gif').show()
        $.getScript(url)
    $(window).scroll()
