$ ->
  $("meta[name='user-id']").each () ->
    mixpanel.identify $(this).attr("content")
    mixpanel.register_once 'Initial Referrer': document.referrer

  titleAndAttrsFor = (elt) ->
    title = $.trim( $(elt).attr("title") || $(elt).text() )
    track = $(elt).data("track")
    attrs = if track isnt "" then JSON.parse("{ #{track} }") else {}
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

  $("form[data-track]").submit (evt) ->
    from = $(this)
    evt.preventDefault()
    track "Submitted", this, () -> form.submit()

  $("body#episodes.show").each () ->
    refCode  = $.url().param('ref')
    referrer = document.referrer
    episodeId = $(this).find("article.episode").attr("id")
    mixpanel.track "Episode Viewed", "Episode" : episodeId, "Ref code" : refCode, "Referrer" : referrer

  $("body#home.index").each () ->
    refCode  = $.url().param('ref')
    referrer = document.referrer
    mixpanel.track "Homepage Viewed", "Ref code" : refCode, "Referrer" : referrer