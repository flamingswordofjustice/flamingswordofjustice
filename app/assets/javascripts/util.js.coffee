window.util =
  interval: (ms, fn) -> setInterval fn, ms
  timeout:  (ms, fn) -> setTimeout fn, ms
  doto: (o, fn) -> fn(o); o # K combinator
  meta: (name) -> $("meta[name='#{name}']").attr("content")
  og:   (name) -> $("meta[property='og:#{name}']").attr("content")

Array.prototype.remove = (from, to) ->
  rest = @slice (to || from) + 1 || this.length
  @length = if from < 0 then this.length + from else from
  @push.apply this, rest
