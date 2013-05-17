
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
    affixable = $(this)
    pos = affixable.position()
    parent    = affixable.parent()
    footer    = $("#footer")
    header    = $(".page-header")
    navbar    = $(".navbar")
    offset    = 50

    # TODO There must be a way to calculate the offset dynamically.

    affixable.affix offset: {
      top: () -> header.height() + navbar.height() + offset,
      bottom: 260
    }

    affixable.width parent.width()
    $(window).resize () ->
      affixable.width parent.width()

  $(".full-play-controls").each () ->
    player = $(this).find ".play-episode"
    controls = player.find(".jp-play, .jp-pause")

    resizer = () ->
      width = player.width()
      height = ( width / 16.0 ) * 9.0
      player.css(height: height)
      controls.find("i").css lineHeight: height + "px", fontSize: (height / 2) + "px"

    resizer()
    $(window).resize resizer

  $('.image-gallery').magnificPopup
    delegate: 'a',
    type: 'image',
    mainClass: 'mfp-fade',
    removalDelay: 300,
    gallery: { enabled: true }
