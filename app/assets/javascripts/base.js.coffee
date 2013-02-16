jQuery ->
  $("[data-mp3-uri]").each () ->
    uniqueId = $(this).closest(".episode").attr("id")
    mp3Uri = $(this).data("mp3-uri")

    $(this).jPlayer
      ready: () ->
        $(this).jPlayer "setMedia", mp3: mp3Uri

      swfPath: ""
      supplied: "mp3"
      cssSelectorAncestor: "#" + uniqueId
