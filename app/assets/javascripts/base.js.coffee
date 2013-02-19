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

  $(".share-link").each () ->
    $(this).zclip copy: $(this).prev("input").val()

  $("form.subscribe a.submit").on "click", () -> $(this).closest("form").submit()

  $("form.subscribe").on "ajax:complete", () -> $(this).find("a.submit").text("Thanks!")

  # $("form.subscribe").on "click", ".submit"

  # $("form.subscribe").submit (evt) ->
  #   evt.preventDefault()
  #   form = $(this)

  #   $.post form.attr("action"), "subscriber[email]": form.find("input.email").val(), () ->
  #     form.find("submit").text("Thanks!")
