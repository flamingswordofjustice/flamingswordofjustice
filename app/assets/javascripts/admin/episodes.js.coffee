$ ->
  # TODO Refactor with Knockout and eliminate this file (mostly).
  $('#episode-info').each () ->
    panel = $(this)
    id = panel.data("id")
    trackingUri = panel.data("tracking-uri")
    mixpanelUri = panel.data("mixpanel-uri")

    $.get mixpanelUri, (resp) ->
      formatPct = (n) -> (parseFloat(n) * 100).toFixed(2) + "%"

      totalVisits     = resp["Liked"][0]["count"]
      listensFunnel   = resp["Liked"][1]["count"]
      listensPerVisit = formatPct(resp["Liked"][1]["step_conv_ratio"])
      likesFunnel     = resp["Liked"][2]["count"]
      likesPerListen  = formatPct(resp["Liked"][2]["step_conv_ratio"])
      subscFunnel     = resp["Subscribed"][2]["count"]
      subscPerListen  = formatPct(resp["Subscribed"][2]["step_conv_ratio"])

      panel.find("tr.total td.total_visits").text totalVisits
      panel.find("tr.total td.listens_per_visit").text listensFunnel
      panel.find("tr.aggregate td.listens_per_visit").text listensPerVisit
      panel.find("tr.total td.likes_per_listen").text likesFunnel
      panel.find("tr.aggregate td.likes_per_listen").text likesPerListen
      panel.find("tr.total td.subscribes_per_listen").text subscFunnel
      panel.find("tr.aggregate td.subscribes_per_listen").text subscPerListen

    $.get trackingUri + "/admin/episodes/#{id}", (resp) ->
      series = ( [ l.timestamp, l.count ] for l in resp.listens )

      panel.find("tr.total td.total_listens").text resp.totalListens
      panel.find("tr.total td.total_listen_time").text strftimeUTC("%d days %T", new Date(resp.totalListenTime))
      panel.find("tr.aggregate td.total_listen_time").text strftimeUTC("%T", new Date(resp.avgListenTime))

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

