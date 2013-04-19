window.util =
  interval: (ms, fn) -> setInterval fn, ms
  timeout:  (ms, fn) -> setTimeout fn, ms
  doto: (o, fn) -> fn(o); o # K combinator
