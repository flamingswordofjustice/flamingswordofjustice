EpisodeFilter = (list) ->
  @filters  = ko.observable([])
  @loaded   = false

  @clearFilters = () -> @filters([])

  ko.computed () =>
    filts = @filters()

    if filts.length is 0
      list.mixitup "filter", "all"
    else
      filter = filts.join(" ")
      console.log "bam"

      if !@loaded
        $.get("/episodes/rest").done (resp) =>
          $("nav.pagination").hide()
          $("#episode-list").append(resp.episodes).mixitup("remix")
          @loaded = true
          list.mixitup "filter", filter
      else
        list.mixitup "filter", filter

  return this

ko.bindingHandlers.chosen =
  init: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
    observable = valueAccessor()

    $(element).chosen(allow_single_deselect: true, width: "100%").on "change", () ->
      newVal = $(element).val() || []
      curVal = observable()

      if newVal.join(" ") isnt curVal.join(" ")
        observable newVal

    presets = $(element).data("val").split(",")
    console.log "presets are", presets, "data is", $(element).data("val")
    observable(presets) if ( presets.length isnt 0 or presets[0] isnt "" )

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
