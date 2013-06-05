$ ->
  Listener = Backbone.Model.extend()

  ListenerViewModel = (model) ->
    for key, value of model.attributes
      this[key] = kb.observable model, key

    @listenTimeFormatted = ko.computed () =>
      strftimeUTC "%T", new Date(@totalListenTime())

    @startTimeFormatted = ko.computed () =>
      strftime "%F %T", new Date(@startTime())

    @isVisible = ko.observable false

    @toggle = (vm, evt) =>
      @isVisible !@isVisible()

    this

  Query = () ->
    params = ['episodeId', 'state']

    this[p] = ko.observable() for p in params

    @toJSON = () ->
      o = {}
      o[p] = this[p]() for p in params
      o

    this

  $("select").chosen()

  $("table.listeners").each () ->
    table = $(this)
    trackingUri = table.data("tracking-uri")

    query = new Query()
    listenerColl = new Backbone.Collection([], { model: Listener, url: trackingUri + "/admin/listeners" });

    update = () -> listenerColl.fetch data: query.toJSON(), dataType: 'jsonp'
    update()
    setInterval update, 1000

    listeners = kb.collectionObservable listenerColl,
      view_model: ListenerViewModel,
      comparator: (listenerA, listenerB) ->
        if listenerA.startTime() < listenerB.startTime() then 1 else -1

    activeListener = ko.observable()

    ko.applyBindings
      listeners: listeners
      activeListener: activeListener
      query: query
      selectListener: (listener) ->
        if listener is activeListener() then activeListener(null) else activeListener(listener)
      isActive: (listener) ->
        listener is activeListener()
