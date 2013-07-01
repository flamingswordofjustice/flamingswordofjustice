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
    track "Clicked", this, () -> window.location = a.attr("href")

  mixpanel.track_forms "form.navbar-search", "Submitted Search", (elt) -> titleAndAttrsFor(elt)[1]

  $("form.subscribe").each () ->
    form = $(this)
    submit = form.find("a.submit")

    submit.on "click", (evt) -> form.submit(); evt.preventDefault();
    form.on "ajax:complete", () ->
      mixpanel.track "Submitted Subscribe", titleAndAttrsFor(form)[1]
      submit.find("span").text(submit.data("message"))


  $("body#episodes.show").each () ->
    episodeId = $(this).find("article.episode").attr("id")
    mixpanel.track "Episode Viewed", "Episode" : episodeId, "Ref code" : refCode, "Referrer" : referrer, "Player" : util.meta("player")

  $("body#home.index").each () ->
    mixpanel.track "Homepage Viewed", "Ref code" : refCode, "Referrer" : referrer

  $.ajaxSetup cache: true

  episodeFor = (elt) ->
    $(elt).closest("article.episode").attr("id")

  $.getScript '//connect.facebook.net/en_UK/all.js', () ->
    window.fbAsyncInit = () ->
      protocol = if 'https:' is document.location.protocol then 'https://' else 'http://'
      FB.init
        appId: util.meta("facebook-app-id")
        status: true
        xfbml: true

      FB.Event.subscribe 'edge.create', (url, evt) ->
        mixpanel.track "Facebook like", "URL": url, "Ref code": refCode, "Episode": episodeFor(evt.dom)

      FB.Event.subscribe 'edge.remove', (url, evt) ->
        mixpanel.track "Facebook unlike", "URL": url, "Ref code": refCode, "Episode": episodeFor(evt.dom)

  $.getScript '//platform.twitter.com/widgets.js', (t) ->
    window.twttr.ready (t) ->
      t.events.bind 'click', (evt) ->
        mixpanel.track "Twitter click", "Click type": evt.region, "Ref code": refCode, "Episode" : episodeFor(evt.target)

      t.events.bind 'tweet', (evt) ->
        mixpanel.track "Twitter tweet", "Ref code": refCode, "Episode" : episodeFor(evt.target)

      t.events.bind 'follow', (evt) ->
        mixpanel.track "Twitter follow", "Ref code": refCode, "Screen name" : evt.data.screen_name
