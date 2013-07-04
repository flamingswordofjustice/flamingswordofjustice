$ ->
  $(".youtube-placeholder").each () ->
    youtubeId = $(this).data("youtube-id")
    eltId     = $(this).attr("id")
    url       = "http://www.youtube.com/v/#{youtubeId}?enablejsapi=1&playerapiid=#{eltId}&version=3"
    swfobject.embedSWF url, eltId, "100%", "356", "8", null, null, { allowScriptAccess: "always" }, { id: eltId, class: "youtube-player" }

  window.onYouTubePlayerReady = (id) ->
    player = $("#" + id)
    refCode   = util.meta("ref-code")
    episodeId = player.closest("article.episode").attr("id")

    resizer = () ->
      width = player.width()
      height = ( ( width / 16.0 ) * 9.0 ) + 100 # Adjust for play controls
      player.css(height: height)

    resizer()
    $(window).resize resizer

    window.trackYoutubePlayerState = (stateId) ->
      player = $("#" + id)
      if stateId is 1 and !player.attr("data-played")?
        player.attr "data-played", "played"
        mixpanel.track "Episode played",
          "Episode": episodeId,
          "Ref code": refCode,
          "Player": "youtube"

    player[0].addEventListener "onStateChange", "trackYoutubePlayerState"

  $("[data-mp3-uri]").each () ->
    root         = $(this)
    controls     = root.closest(".play-controls, .full-play-controls")
    if controls.hasClass("unpublished") then return

    article      = controls.closest("article.episode")
    episodeId    = article.attr("id")
    episodeState = article.data("state")
    controlsId   = controls.attr("id")
    mp3Uri       = root.data("mp3-uri")
    trackingUri  = root.data("tracking-uri")
    swfPath      = root.data("swf-path")
    sessionId    = root.data("play-session")
    userId       = root.data("user-session")

    shouldTrack  = trackingUri? and trackingUri isnt ""
    refCode      = util.meta("ref-code")
    started      = false
    heartbeat    = null

    notify = (evt) ->
      type    = evt.type.replace(/jPlayer_/, '')
      playing = ["play", "seeked", "playing"].indexOf(type) >= 0

      if !started and playing
        started = true
        mixpanel.track "Episode played",
          "Episode": episodeId,
          "Ref code": refCode,
          "Player": "audio"

      clearInterval(heartbeat) if heartbeat?

      return unless started and shouldTrack

      params =
        userId:       userId
        sessionId:    sessionId
        episodeId:    episodeId
        episodeState: episodeState
        type:         type
        ref:          refCode
        progressed:   Math.round(evt.jPlayer.status.currentTime * 1000)

      ping = () ->
        params.timestamp = new Date()
        $.ajax trackingUri + "/events", type: "post", data: params

      ping()
      heartbeat = setInterval ping, 10000

    root.jPlayer
      preload: "none"
      swfPath: swfPath
      supplied: "mp3"
      cssSelectorAncestor: "#" + controlsId

      ready: () -> root.jPlayer "setMedia", mp3: mp3Uri
      play:    notify
      seeked:  notify
      playing: notify
      pause:   notify
      seeking: notify
      error:   notify
      stalled: notify
      abort:   notify
      emptied: notify
      ended:   notify

  $.jPlayer.timeFormat.showHour = true
