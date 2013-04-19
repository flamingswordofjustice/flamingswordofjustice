$ ->
  updater = (label, target, from) ->
    () ->
      $.Deferred (def) ->
        request = $.ajax "/stats",
          method: "get"
          timeout: 1000
          data:
            target: target
            from: from

        request.done (response) ->
          if response.length is 0
            def.reject "That stat was not found."
          else
            datapoints = response[0].datapoints.map (p) -> [ p[1] * 1000, p[0] ]
            def.resolve data: datapoints, label: label

  updateAll = (updaters...) ->
    $.when.apply(null, updaters.map((u) -> u[0]()))

  timeChart = (elt, format, updaters...) ->
    plot = null

    updateAll(updaters).done (data...) ->
      plot = $.plot elt, data,
        xaxis:
          mode: "time",
          timeformat: format
          timezone: "browser"
        legend: false
        grid:
          color: "#bbb"
        series:
          shadowSize: 0

    util.interval 10000, () ->
      updateAll(updaters).done (data...) ->
        plot.setData data
        plot.setupGrid()
        plot.draw()

  $("#live-listeners").each () ->
    liveListens = updater("Live published listens", "sumSeries(stats.gauges.listens.*.published.live)", "-6h")
    timeChart this, "%I:%M%p", liveListens

  $("#total-listeners").each () ->
    totalListens = updater("Total published listens", "sumSeries(stats.gauges.listens.*.published.total)", "-6h")
    timeChart this, "%I:%M%p", totalListens
