jQuery ->
  $("[data-mp3-uri]").each () ->
    uniqueId = $(this).closest(".play-controls").attr("id")
    mp3Uri = $(this).data("mp3-uri")

    $(this).jPlayer
      ready: () ->
        $(this).jPlayer "setMedia", mp3: mp3Uri

      play: () ->
        $(this).closest(".play-controls").addClass("playing")

      preload: "none"
      swfPath: ""
      supplied: "mp3"
      cssSelectorAncestor: "#" + uniqueId

  $.jPlayer.timeFormat.showHour = true

  $(".share-link").each () ->
    input = $(this).prev("input")
    $(this).zclip
      copy: input.val()
      afterCopy: () -> input.focus().select()

  $("form.subscribe").each () ->
    form = $(this)
    submit = form.find("a.submit")

    submit.on "click", () -> form.submit()
    form.on "ajax:complete", () -> submit.text(submit.data("message"))
