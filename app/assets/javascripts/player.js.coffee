$ ->
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
    ref          = $.url().param('ref')
    started      = false
    heartbeat    = null

    notify = (evt) ->
      type    = evt.type.replace(/jPlayer_/, '')
      playing = ["play", "seeked", "playing"].indexOf(type) >= 0
      started = started || playing
      clearInterval(heartbeat) if heartbeat?

      return unless started and shouldTrack

      params =
        userId:       userId
        sessionId:    sessionId
        episodeId:    episodeId
        episodeState: episodeState
        type:         type
        ref:          ref
        progressed:   Math.round(evt.jPlayer.status.currentTime * 1000)

      console.log params

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
