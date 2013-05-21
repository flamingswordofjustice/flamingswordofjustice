$ ->
  Listener = Backbone.Model.extend()

  ListenerViewModel = (model) ->
    for key, value of model.attributes
      this[key] = kb.observable model, key

    @listenTimeFormatted = ko.computed () =>
      strftimeUTC "%H:%M:%S", new Date(@totalListenTime())

    @state = ko.computed () =>
      if @playing() then "playing" else "stopped"

    this

  $("select.episode").chosen().change (evt) ->
    console.log evt

  $("table.listeners").each () ->
    table = $(this)
    trackingUri = table.data("tracking-uri")

    listenerColl = new Backbone.Collection([], { model: Listener, url: trackingUri + "/admin/listeners" });

    update = () -> listenerColl.fetch dataType: 'jsonp'
    update()
    setInterval update, 1000

    listeners = kb.collectionObservable listenerColl, view_model: ListenerViewModel
    activeListener = ko.observable()

    ko.applyBindings
      listeners: listeners
      activeListener: activeListener,
      selectListener: (listener) ->
        if listener is activeListener() then activeListener(null) else activeListener(listener)
      isActive: (listener) ->
        listener is activeListener()
