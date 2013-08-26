window.util =
  interval: (ms, fn) -> setInterval fn, ms
  timeout:  (ms, fn) -> setTimeout fn, ms
  doto: (o, fn) -> fn(o); o # K combinator
  meta: (name) -> $("meta[name='#{name}']").attr("content")
  og:   (name) -> $("meta[property='og:#{name}']").attr("content")
  mixparams: (extra) ->
    baseParams =
      "Episode"       : util.meta("episode-id")
      "Player"        : util.meta("player")
      "Layout"        : util.meta("layout")
      "Ref code"      : util.meta("ref-code")
      "Modal enabled" : util.meta("modal-enabled")

    $.extend {}, baseParams, extra

Array.prototype.remove = (from, to) ->
  rest = @slice (to || from) + 1 || this.length
  @length = if from < 0 then this.length + from else from
  @push.apply this, rest
