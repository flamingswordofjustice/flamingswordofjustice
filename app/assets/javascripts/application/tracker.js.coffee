$ ->
  refCode  = util.meta("ref-code")
  mixpanel.identify util.meta("user-id")
  mixpanel.register_once 'Initial Referrer': document.referrer

  eltAttrsFor = (elt) ->
    track = $(elt).data("track")
    attrs = if ( track? and track isnt "" ) then JSON.parse("{ #{track} }") else {}
    attrs['Page Name'] = document.title
    util.mixparams attrs

  track = (verb, elt, done) ->
    title = $(elt).data("event") || $(elt).attr("title") || $(elt).text()
    title = $.trim title

    mixpanel.track "#{verb} #{title}", eltAttrsFor(elt), done
    setTimeout done, 300

  $("a[data-track], button[data-track]").click (evt) ->
    a = $(this)
    evt.preventDefault()
    track "Clicked", this, () ->
      window.location = a.attr("href") if a.attr("href") isnt "#"

  mixpanel.track_forms "form.navbar-search", "Submitted Search", (elt) -> eltAttrsFor(elt)

  $("form.subscribe").each () ->
    form = $(this)
    submitBtn = form.find("a.submit")
    form.on "submit", (evt) -> submitBtn.attr("disabled", "disabled")
    submitBtn.on "click", (evt) -> form.submit(); evt.preventDefault()

  $(".subscribe-join-social form.subscribe").on "ajax:complete", () ->
    mixpanel.track "Submitted Subscribe", eltAttrsFor(this)
    submit.find("span").text submit.data("message")

  $(".subscribe-after form.subscribe").on "ajax:complete", () ->
    mixpanel.track "Submitted Subscribe", eltAttrsFor(this)
    $(this).slideUp "fast", () ->
      $(this).nextAll(".thanks").slideDown("fast");

  $("body#episodes.show, body#episodes.alt").each () ->
    mixpanel.track "Episode Viewed", util.mixparams()

    $("#share-modal").on "shown", () ->
      mixpanel.track "Share modal shown", util.mixparams()

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
        mixpanel.track "Submitted Subscribe", util.mixparams("Source" : "modal")

        util.timeout 2000, () -> modal.modal("hide")

  $("body#home.index").each () ->
    mixpanel.track "Homepage Viewed", "Ref code" : refCode

  $.ajaxSetup cache: true

  if window.FB?
    FB.init
      appId: util.meta("facebook-app-id")
      status: true
      xfbml: true

    FB.Event.subscribe 'edge.create', (url, evt) ->
      mixpanel.track "Facebook like", util.mixparams("URL": url)

    FB.Event.subscribe 'edge.remove', (url, evt) ->
      mixpanel.track "Facebook unlike", util.mixparams("URL": url)

  if window.twttr?
    twttr.events.bind 'click', (evt) ->
      mixpanel.track "Twitter click", util.mixparams("Click type": evt.region)

    twttr.events.bind 'tweet', (evt) ->
      mixpanel.track "Twitter tweet", util.mixparams()

    twttr.events.bind 'follow', (evt) ->
      mixpanel.track "Twitter follow", util.mixparams("Screen name" : evt.data.screen_name)

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
    evt.preventDefault()
    params      = fbParamsFromOpenGraph()
    url         = $(this).data("url")
    trackerData = util.mixparams("URL": url)

    mixpanel.track "Facebook share click", trackerData
    FB.ui params, (evt) -> mixpanel.track "Facebook share success", trackerData if evt?
