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
    playing      = false
    heartbeat    = null

    notify = (evt) ->
      return unless shouldTrack

      unless heartbeat?
        heartbeat = setInterval (-> notify(type: "heartbeat")), 10000

      type    = evt.type.replace(/jPlayer_/, '')
      playing = ["play", "seeked", "playing"].indexOf(type) >= 0

      params =
        userId:       userId
        sessionId:    sessionId
        episodeId:    episodeId
        episodeState: episodeState
        type:         type
        ref:          ref
        timestamp:    new Date()

      console.log type, params

      $.ajax trackingUri + "/events", type: "post", data: params

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
