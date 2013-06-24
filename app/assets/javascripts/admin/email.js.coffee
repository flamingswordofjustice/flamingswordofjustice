$ ->
  $("body.admin_emails").each () ->
    subject = $("#email_subject")
    episode = $("#email_episode_id")
    bodyRow = $("#email_body_input")

    toggleBody = () ->
      if episode.val() is ""
        bodyRow.slideDown()
      else
        bodyRow.slideUp()

    episode.change () ->
      id = $(this).val()

      if id is ''
        subject.val ''
      else
        $.get("/episodes/#{$(this).val()}.json").done (resp) ->
          subject.val resp.headline || resp.title

      toggleBody()

    toggleBody()

