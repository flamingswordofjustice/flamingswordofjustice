$ ->
  refCode  = util.meta("ref-code")
  referrer = document.referrer

  mixpanel.identify util.meta("user-id")
  mixpanel.register_once 'Initial Referrer': document.referrer

  titleAndAttrsFor = (elt) ->
    title = $(elt).data("event") || $(elt).attr("title") || $(elt).text()
    title = $.trim title

    track = $(elt).data("track")
    attrs = if ( track? and track isnt "" ) then JSON.parse("{ #{track} }") else {}
    attrs['Page Name'] = document.title
    [ title, attrs ]

  track = (verb, elt, done) ->
    [ title, attrs ] = titleAndAttrsFor elt
    mixpanel.track "#{verb} #{title}", attrs, done
    setTimeout done, 300

  $("a[data-track], button[data-track]").click (evt) ->
    a = $(this)
    evt.preventDefault()
    track "Clicked", this, () ->
      window.location = a.attr("href") if a.attr("href") isnt "#"

  mixpanel.track_forms "form.navbar-search", "Submitted Search", (elt) -> titleAndAttrsFor(elt)[1]

  $("form.subscribe").each () ->
    form = $(this)
    submitBtn = form.find("a.submit")
    form.on "submit", (evt) -> submitBtn.attr("disabled", "disabled")
    submitBtn.on "click", (evt) -> form.submit(); evt.preventDefault()

  $(".subscribe-join-social form.subscribe").on "ajax:complete", () ->
    mixpanel.track "Submitted Subscribe", titleAndAttrsFor($(this))[1]
    submit.find("span").text(submit.data("message"))

  $(".subscribe-after form.subscribe").on "ajax:complete", () ->
    mixpanel.track "Submitted Subscribe", titleAndAttrsFor($(this))[1]
    $(this).slideUp "fast", () ->
      $(this).nextAll(".thanks").slideDown("fast");

  $("body#episodes.show, body#episodes.alt").each () ->
    episodeId = $(this).find("article.episode").attr("id")
    mixpanel.track "Episode Viewed", "Episode" : episodeId, "Ref code" : refCode, "Referrer" : referrer, "Player" : util.meta("player")

    $("#share-modal").on "shown", () ->
      mixpanel.track "Share modal shown", "Episode" : episodeId, "Ref code" : refCode, "Referrer" : referrer, "Player" : util.meta("player")

    util.timeout 1000, () ->
      $("#share-modal").modal("show")

    $("#share-modal").each () ->
      modal = $(this)
      contents = modal.find(".modal-contents")
      width = modal.width()
      innerWidth = width - 50;

      modal.find(".modal-body, .step").width innerWidth

      nextStep = (step) ->
        contents.css(left: width * -1 * step)

      modal.find(".btn-primary").click (evt) ->
        evt.preventDefault(); nextStep(1); mixpanel.track

      modal.find("form.subscribe").on "ajax:complete", (evt) ->
        nextStep(2)
        mixpanel.track "Submitted Subscribe",
          "Episode" : episodeId,
          "Ref code" : refCode,
          "Referrer" : referrer,
          "Player" : util.meta("player"),
          "Source" : "modal"

        util.timeout 2000, () -> modal.modal("hide")

  $("body#home.index").each () ->
    mixpanel.track "Homepage Viewed", "Ref code" : refCode, "Referrer" : referrer

  $.ajaxSetup cache: true

  episodeFor = (elt) ->
    $(elt).closest("article.episode").attr("id")

  if window.FB?
    FB.init
      appId: util.meta("facebook-app-id")
      status: true
      xfbml: true

    FB.Event.subscribe 'edge.create', (url, evt) ->
      mixpanel.track "Facebook like", "URL": url, "Ref code": refCode, "Episode": episodeFor(evt.dom)

    FB.Event.subscribe 'edge.remove', (url, evt) ->
      mixpanel.track "Facebook unlike", "URL": url, "Ref code": refCode, "Episode": episodeFor(evt.dom)

  if window.twttr?
    twttr.events.bind 'click', (evt) ->
      mixpanel.track "Twitter click", "Click type": evt.region, "Ref code": refCode, "Episode" : episodeFor(evt.target)

    twttr.events.bind 'tweet', (evt) ->
      mixpanel.track "Twitter tweet", "Ref code": refCode, "Episode" : episodeFor(evt.target)

    twttr.events.bind 'follow', (evt) ->
      mixpanel.track "Twitter follow", "Ref code": refCode, "Screen name" : evt.data.screen_name

  fbParamsFromOpenGraph = () ->
    {
      method:  "feed"
      app_id:  util.meta("facebook-app-id")
      link:    util.og("url")
      name:    util.og("title")
      caption: document.location.hostname
      description: util.og("description")
    }

  $(".share-buttons .facebook, .btn-facebook").click (evt) ->
    params = fbParamsFromOpenGraph()
    evt.preventDefault()
    episode = episodeFor(this)
    url = $(this).data("url")
    mixpanel.track "Facebook share click", "URL": url, "Ref code": refCode, "Episode": episode
    FB.ui params, (evt) ->
      unless evt.error_code?
        mixpanel.track "Facebook share success", "URL": url, "Ref code": refCode, "Episode": episode
