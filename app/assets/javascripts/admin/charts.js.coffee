data =
  updater: (label, target, from) ->
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
            def.reject "No data found for stat #{target}."
          else
            datapoints = response[0].datapoints.map (p) -> [ p[1] * 1000, p[0] ]
            def.resolve data: datapoints, label: label

  updateAll: (updaters) ->
    $.when.apply(null, updaters.map(-> this()))

charts =
  timeChart: (root, format, updaters) ->
    def = data.updateAll(updaters)

    def.done (data...) ->
      placeholder = $("<div class='placeholder' />").css height: "300px"
      legend = $("<div class='legend'/>")
      $(root).find("ul").remove()
      $(root).append(placeholder).append(legend)

      plot = $.plot placeholder, data,
        xaxis:
          mode: "time",
          timeformat: format
          timezone: "browser"
        legend:
          container: legend
        grid:
          color: "#bbb"
        series:
          shadowSize: 0

      util.interval 10000, () ->
        data.updateAll(updaters).done (data...) ->
          plot.setData data
          plot.setupGrid()
          plot.draw()

    def.fail (error) ->
      $(root).append $("<span class='error' />").text(error)

$ ->
  $(".chart").each () ->
    lines = $(this).find("ul")

    updaters = $(lines).find("li").map () ->
      data.updater $(this).text(), $(this).data("target"), lines.data("from")

    charts.timeChart this, lines.data("format"), updaters

  $(".sparkline").each () ->
    root    = $(this)
    target  = $(this).text()
    getData = data.updater(target, "stats.redirects.#{target}", "-24h")

    getData().done (data) ->
      yValues = data.data.map (p) -> p[1]
      numVals = yValues.length
      root.sparkline yValues[(numVals - 180)..numVals], width: "200px"

