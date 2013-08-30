$ ->
  $(".share-link").each () ->
    input = $(this).prev("input")
    $(this).zclip
      copy: input.val()
      afterCopy: () -> input.focus().select()

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

  $(".affix-wrapper").each () ->
    $(this).height($(this).find(".apply-affix").height())

  $(".apply-affix").each () ->
    affixable = $(this)
    pos = affixable.position()
    parent    = affixable.parent()

    affixable.affix offset: { top: pos.top - 20, bottom: $("#footer").height() + $(".subscribe-after").height() + 50 }

    affixable.width parent.width()
    $(window).resize () -> affixable.width parent.width()

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

  $('.page-header').each () ->
    [ minFontSize, maxFontSize ] = [ 18.0, 64.0 ]
    header     = $(this)
    titleBox   = header.find(".page-header-title")
    title      = titleBox.find("h1")
    numChars   = title.text().length
    logo       = header.find(".page-header-logo img")
    logoRatio  = 1.15
    compressor = switch
      when numChars < 20 then 1.0
      when numChars < 60 then 2.4
      else 3.0

    resizer = () ->
      guessedFontSize = header.width() / (compressor * 10)
      calcedFontSize  = Math.max(Math.min(guessedFontSize, maxFontSize), minFontSize)
      lineHeight      = calcedFontSize + ( calcedFontSize / 3 ) + "px"
      title.css fontSize: calcedFontSize, lineHeight: lineHeight

      newHeight = titleBox.height()
      logo.css height: newHeight, width: newHeight * logoRatio

    $(window).resize(resizer).trigger("resize")

  $("[data-toggle='tooltip']").tooltip(placement: 'bottom')
