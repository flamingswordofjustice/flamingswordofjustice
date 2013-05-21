$ ->
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
    ref          = $.url().param('ref')

    connect = () ->
      socket = io.connect(trackingUri + "/listens", reconnect: true)

      # TODO: If the connection to the server is lost, this will reconnect and treat
      # that connect as another play even if the player isn't running. Fix.
      socket.on 'connect', () -> play(type: 'connect')

    play = (evt) ->
      if shouldTrack
        console.log "play", evt

        if socket?
          type = evt.type.replace(/jPlayer_/, '')
          socket.emit 'play', id: episodeId, state: episodeState, type: type, ref: ref
        else
          connect()

    pause = (evt) ->
      if shouldTrack and socket?
        console.log "pause", evt
        type = evt.type.replace(/jPlayer_/, '')
        socket.emit 'pause', type: type, ref: ref

    close = (evt) ->
      if shouldTrack and socket?
        console.log "end", evt
        type = evt.type.replace(/jPlayer_/, '')
        socket.emit 'close', type: type, ref: ref

    $(this).jPlayer
      preload: "none"
      swfPath: swfPath
      supplied: "mp3"
      cssSelectorAncestor: "#" + controlsId

      ready: () -> $(this).jPlayer "setMedia", mp3: mp3Uri
      play:    play
      seeked:  play
      playing: play
      pause:   pause
      seeking: pause
      error:   pause
      stalled: pause
      abort:   pause
      emptied: pause
      ended:   close

  $.jPlayer.timeFormat.showHour = true
