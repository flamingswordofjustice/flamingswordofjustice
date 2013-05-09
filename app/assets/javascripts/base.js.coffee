
jQuery ->
  $("[data-mp3-uri]").each () ->
    controls     = $(this).closest(".play-controls, .full-play-controls")
    if controls.hasClass("unpublished") then return

    article      = controls.closest("article.episode")
    episodeId    = article.attr("id")
    episodeState = article.data("state")
    controlsId   = controls.attr("id")
    mp3Uri       = $(this).data("mp3-uri")
    trackingUri  = $(this).data("tracking-uri")
    swfPath      = $(this).data("swf-path")
    shouldTrack  = trackingUri? and trackingUri isnt ""
    socket       = null

    connect = () ->
      socket = io.connect(trackingUri, reconnect: true)
      socket.on 'connect', play(id: episodeId, state: episodeState, type: 'connect')

    play = (evt) ->
      if shouldTrack
        console.log "play", evt
        if socket?
          socket.emit 'play', id: episodeId, state: episodeState, type: evt.type
        else
          connect()

    pause = (evt) ->
      if shouldTrack and socket?
        console.log "pause", evt
        socket.emit 'pause', type: evt.type

    $(this).jPlayer
      preload: "none"
      swfPath: swfPath
      supplied: "mp3"
      cssSelectorAncestor: "#" + controlsId

      ready: () -> $(this).jPlayer "setMedia", mp3: mp3Uri
      play:  (evt) -> controls.addClass("playing"); play(evt)
      seeked:  play
      playing: play
      pause:   pause
      seeking: pause
      ended:   pause
      error:   pause
      stalled: pause
      abort:   pause
      emptied: pause

  $.jPlayer.timeFormat.showHour = true

  $(".share-link").each () ->
    input = $(this).prev("input")
    $(this).zclip
      copy: input.val()
      afterCopy: () -> input.focus().select()

  $("form.subscribe").each () ->
    form = $(this)
    submit = form.find("a.submit")

    submit.on "click", (evt) -> form.submit(); evt.preventDefault();
    form.on "ajax:complete", () -> submit.find("span").text(submit.data("message"))

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
