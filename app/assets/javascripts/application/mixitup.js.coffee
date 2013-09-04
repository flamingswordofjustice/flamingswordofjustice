EpisodeFilter = (list) ->
  @topicFilter = ko.observable("")
  @guestFilter = ko.observable([])

  @filters = ko.computed () =>
    topic = @topicFilter()
    guests = @guestFilter()

    if topic is "" and guests.length is 0
      "all"
    else
      dup = guests.slice(0)
      dup.push(topic)
      $.trim dup.join(" ")

  ko.computed () =>
    console.log "topic", @topicFilter(), "guest", @guestFilter(), "total", @filters()
    list.mixitup "filter", @filters()

  return this

ko.bindingHandlers.chosen =
  init: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
    observable = valueAccessor()
    $(element).chosen(allow_single_deselect: true).on "change", () ->
      console.log "val was", $(element).val()
      observable $(element).val() || []

  update: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
    observable = valueAccessor()
    $(element).val(observable()).trigger("liszt:updated")

$ ->
  list = $("#episode-list")
  list.mixitup()
  ko.applyBindings episodeFilter: new EpisodeFilter(list)
