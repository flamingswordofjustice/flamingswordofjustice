jQuery ->
  $("[data-mp3-uri]").each () ->
    controls     = $(this).closest(".play-controls, .full-play-controls")
    article      = controls.closest("article.episode")
    episodeId    = article.attr("id")
    episodeState = article.data("state")
    controlsId   = controls.attr("id")
    mp3Uri       = $(this).data("mp3-uri")
    trackingUri  = $(this).data("tracking-uri")
    shouldTrack  = trackingUri? and trackingUri isnt ""
    socket       = null

    connect = () ->
      socket = io.connect(trackingUri, reconnect: true)
      socket.on 'connect', play

    play = () ->
      if shouldTrack
        if socket?
          socket.emit 'play', id: episodeId, state: episodeState
        else
          connect()

    pause = () ->
      if shouldTrack and socket?
        socket.emit 'pause'

    $(this).jPlayer
      preload: "none"
      swfPath: ""
      supplied: "mp3"
      cssSelectorAncestor: "#" + controlsId

      ready: () -> $(this).jPlayer "setMedia", mp3: mp3Uri
      play:  () -> controls.addClass("playing"); play()
      pause:   pause
      seeking: pause
      seeked:  play
      ended:   pause
      error:   pause
      stalled: pause
      abort:   pause
      empited: pause

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

  $(".apply-affix").each () ->
    pos = $(this).position()
    $(this).css(left: pos.left).affix offset: { top: pos.top - 20, left: pos.left }

