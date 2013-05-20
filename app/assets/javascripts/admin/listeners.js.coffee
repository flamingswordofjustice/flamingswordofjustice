$ ->
  Listener = (attrs) ->
    for key, value of attrs
      this[key] = ko.observable(value)

    @listenTimeFormatted = ko.computed () =>
      strftime "%I:%M:%S", new Date(@totalListenTime()),

    @state = ko.computed () =>
      if @playing() then "playing" else "stopped"

    @transition = ko.computed () =>
      listens = @listens()

      listens[listens.length - 1].type.replace /jPlayer_/, ''

    this

  $("table.listeners").each () ->
    table = $(this)
    activeListener = ko.observable()
    listeners = ko.observableArray()
    trackingUri = table.data("tracking-uri")

    update = () ->
      req = $.ajax trackingUri + "/admin/episodes", type: 'get', crossDomain: true, dataType: 'jsonp'

      req.error () ->
        console.log 'failure', arguments

      req.success (resp) ->
        list = ( new Listener(listener) for listener in resp )
        listeners list

    update()

    setInterval update, 1000

    selectListener = (listener) =>
      activeListener listener

    ko.applyBindings listeners: listeners, activeListener: activeListener, selectListener: selectListener
