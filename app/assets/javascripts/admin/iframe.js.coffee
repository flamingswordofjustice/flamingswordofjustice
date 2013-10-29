$ ->
  $("#main_content iframe.preview").load () ->
    console.log "hello world"
    $(this).height $(this).contents().height()
