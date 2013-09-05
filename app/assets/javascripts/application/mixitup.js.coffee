EpisodeFilter = (list) ->
  @filters = ko.observable([])

  @clearFilters = () -> @filters([])

  ko.computed () =>
    filts = @filters()
    list.mixitup "filter", if filts.length is 0 then "all" else filts.join(" ")

  return this

ko.bindingHandlers.chosen =
  init: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
    observable = valueAccessor()
    $(element).chosen(allow_single_deselect: true, width: "100%").on "change", () ->
      newVal = $(element).val() || []
      curVal = observable()

      if newVal.join(" ") isnt curVal.join(" ")
        observable newVal

  update: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
    observable = valueAccessor()
    curVal = $(element).val() || []
    newVal = observable()

    if newVal.join(" ") isnt curVal.join(" ")
      $(element).val(if newVal.length is 0 then null else newVal).trigger("chosen:updated")

$ ->
  list = $("#episode-list")
  list.mixitup()
  ko.applyBindings episodeFilter: new EpisodeFilter(list)
