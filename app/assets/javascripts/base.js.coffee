$ ->
  $(".share-link").each () ->
    input = $(this).prev("input")
    $(this).zclip
      copy: input.val()
      afterCopy: () -> input.focus().select()

  $("form.subscribe").each () ->
    form = $(this)
    submit = form.find("a.submit")

    submit.on "click", (evt) -> form.submit(); evt.preventDefault();
    form.on "ajax:complete", () -> submit.find("span").text(submit.data("message"))

  $(".episode.live").each () ->
    episode = $(this)
    uri = episode.data("uri")
    pollInterval = parseInt(episode.data("poll"), 10) * 1000
    showNotes = episode.find(".show-notes")

    updateShowNotes = () ->
      $.get uri, (response) ->
        if showNotes.html() != response.show_notes
          showNotes.html response.show_notes
        if response.state is "live"
          util.timeout pollInterval, updateShowNotes

    updateShowNotes()

  $(".apply-affix").each () ->
    affixable = $(this)
    pos = affixable.position()
    parent    = affixable.parent()
    footer    = $("#footer")
    header    = $(".page-header")
    navbar    = $(".navbar")
    offset    = 50

    # TODO There must be a way to calculate the offset dynamically.

    affixable.affix offset: {
      top: () -> header.height() + navbar.height() + offset,
      bottom: 260
    }

    affixable.width parent.width()
    $(window).resize () ->
      affixable.width parent.width()

  $(".full-play-controls").each () ->
    player = $(this).find ".play-episode"
    controls = player.find(".jp-play, .jp-pause")

    resizer = () ->
      width = player.width()
      height = ( width / 16.0 ) * 9.0
      player.css(height: height)
      controls.find("i").css lineHeight: height + "px", fontSize: (height / 2) + "px"

    resizer()
    $(window).resize resizer

  $('.image-gallery').magnificPopup
    delegate: 'a',
    type: 'image',
    mainClass: 'mfp-fade',
    removalDelay: 300,
    gallery: { enabled: true }

  $("meta[name='user-id']").each () ->
    mixpanel.identify $(this).attr("content")
    mixpanel.register_once 'Initial Referrer': document.referrer

  titleAndAttrsFor = (elt) ->
    title = $(elt).attr("title") || $(elt).text()
    track = $(elt).data("track")
    attrs = if track isnt "" then JSON.parse("{ #{track} }") else {}
    attrs['Page Name'] = document.title
    [ title, attrs ]

  $("a[data-track], button[data-track]").click (evt) ->
    [ title, attrs ] = titleAndAttrsFor this
    mixpanel.track_links this, "Clicked #{title}", attrs
    evt.preventDefault()

  $("form[data-track]").submit (evt) ->
    [ title, attrs ] = titleAndAttrsFor this
    mixpanel.track_forms this, "Submitted #{title}", attrs

