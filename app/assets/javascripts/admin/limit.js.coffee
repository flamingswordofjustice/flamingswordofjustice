$ ->
  $("[maxlength]").each () ->
    input     = $(this)
    counter   = input.next(".inline-hints").find(".charlimit")
    maxlength = parseInt input.attr("maxlength"), 10

    unless counter.length is 0
      input.bind 'input', () ->
        charsRemaining = maxlength - input.val().length
        counter.text "Characters remaining: #{charsRemaining}. "

      input.trigger 'input'
