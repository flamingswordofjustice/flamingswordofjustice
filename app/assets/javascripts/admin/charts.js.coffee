$ ->
  updater = (label, target, from) ->
    () ->
      $.Deferred (def) ->
        request = $.ajax "http://stats.fsj.fm/render",
          method: "get"
          dataType: "jsonp"
          jsonp: "jsonp"
          timeout: 1000
          data:
            target: target
            from: from
            format: "json"

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
        console.log "updating"
        # plot.setData slide.points()
        # plot.resize()
        # plot.setupGrid()
        # plot.draw()

        plot.setData data
        plot.setupGrid()
        plot.draw()

  $("#live-listeners").each () ->
    liveListens = updater("Live published listens", "sumSeries(stats.gauges.listens.*.published.live)", "-6h")
    timeChart this, "%I:%M%p", liveListens

  $("#total-listeners").each () ->
    totalListens = updater("Total published listens", "sumSeries(stats.gauges.listens.*.published.total)", "-6h")
    timeChart this, "%I:%M%p", totalListens
