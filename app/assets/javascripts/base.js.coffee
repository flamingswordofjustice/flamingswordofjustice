jQuery ->

  $("[data-mp3-uri]").each () ->
    controls = $(this).closest(".play-controls")
    episodeId = controls.closest("article.episode").attr("id")
    uniqueId = controls.attr("id")
    mp3Uri = $(this).data("mp3-uri")
    socket = null

    $(this).jPlayer
      ready: () ->
        $(this).jPlayer "setMedia", mp3: mp3Uri

      play: () ->
        console.log 'play'
        $(this).closest(".play-controls").addClass("playing")
        socket = io.connect("http://localhost:5000", reconnect: true)
        socket.emit 'play', id: episodeId

      pause: () ->
        console.log 'pause'
        socket.emit 'pause'

      preload: "none"
      swfPath: ""
      supplied: "mp3"
      cssSelectorAncestor: "#" + uniqueId

  $.jPlayer.timeFormat.showHour = true

  $(".share-link").each () ->
    input = $(this).prev("input")
    $(this).zclip
      copy: input.val()
      afterCopy: () -> input.focus().select()

  $("form.subscribe").each () ->
    form = $(this)
    submit = form.find("a.submit")

    submit.on "click", () -> form.submit()
    form.on "ajax:complete", () -> submit.text(submit.data("message"))

  $(".episode.live").each () ->
    episode = $(this)
    uri = episode.data("uri")
    pollInterval = parseInt(episode.data("poll"), 10) * 1000

    updateShowNotes = () ->
      $.get uri, (response) ->
        episode.find(".show-notes").html response.show_notes
        if response.state is "live"
          util.timeout pollInterval, updateShowNotes

    updateShowNotes()

