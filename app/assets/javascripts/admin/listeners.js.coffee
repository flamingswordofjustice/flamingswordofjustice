$ ->
  Listener = Backbone.Model.extend()

  ListenerViewModel = (model) ->
    for key, value of model.attributes
      this[key] = kb.observable model, key

    @listenTimeFormatted = ko.computed () =>
      strftimeUTC "%H:%M:%S", new Date(@totalListenTime())

    @startTimeFormatted = ko.computed () =>
      strftime "%F %T", new Date(@startTime())

    @isVisible = ko.observable false

    @toggle = (vm, evt) =>
      @isVisible !@isVisible()

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

    listeners = kb.collectionObservable listenerColl,
      view_model: ListenerViewModel,
      comparator: (listenerA, listenerB) ->
        if listenerA.startTime() < listenerB.startTime() then 1 else -1

    activeListener = ko.observable()

    ko.applyBindings
      listeners: listeners
      activeListener: activeListener,
      selectListener: (listener) ->
        if listener is activeListener() then activeListener(null) else activeListener(listener)
      isActive: (listener) ->
        listener is activeListener()
