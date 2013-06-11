$ ->
  # TODO Refactor with Knockout and eliminate this file (mostly).
  $('#episode-info').each () ->
    panel = $(this)
    id = panel.data("id")
    trackingUri = panel.data("tracking-uri")

    $.get trackingUri + "/admin/episodes/#{id}", (resp) ->
      series = ( [ l.timestamp, l.count ] for l in resp.listens )

      panel.find("td.total_listens").text resp.totalListens
      panel.find("td.total_listen_time").text strftimeUTC("%d days %T", new Date(resp.totalListenTime))
      panel.find("td.avg_listen_time").text strftimeUTC("%T", new Date(resp.avgListenTime))

      panel.find(".custom-chart").each () ->
        root = this
        height = 200

        placeholder = $("<div class='placeholder' />").css height: "#{height}px"
        legend = $("<div class='legend'/>")
        $(root).find("ul").remove()
        $(root).append(placeholder).append(legend)

        plot = $.plot placeholder, [ series ],
          xaxis:
            mode: "time",
            timezone: "GMT"
          lines:
            steps: true
          legend:
            container: legend
            labelFormatter: (label, series) ->
              point = series.data[series.data.length - 2]
              label + " (#{point[1]})"
          grid:
            color: "#bbb"
          series:
            shadowSize: 0

