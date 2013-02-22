jQuery ->
  $("[data-mp3-uri]").each () ->
    uniqueId = $(this).closest(".episode").attr("id")
    mp3Uri = $(this).data("mp3-uri")

    $(this).jPlayer
      ready: () ->
        $(this).jPlayer "setMedia", mp3: mp3Uri

      play: () ->
        $(this).closest(".play-controls").addClass("playing")

      pause: () ->
        $(this).closest(".play-controls").removeClass("playing")

      swfPath: ""
      supplied: "mp3"
      cssSelectorAncestor: "#" + uniqueId

  $(".share-link").each () ->
    input = $(this).prev("input")
    $(this).zclip
      copy: input.val()
      afterCopy: () -> input.focus().select()

  $("form.subscribe a.submit").on "click", () -> $(this).closest("form").submit()

  $("form.subscribe").on "ajax:complete", () -> $(this).find("a.submit").text("Awesome job.")
